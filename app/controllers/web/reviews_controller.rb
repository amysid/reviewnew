class Web::ReviewsController < ApplicationController
	include CommonConcern
	def get_reviews
		@product =  Product.find_by(id: params[:id])
		@review = @product.reviews.new(require_params)
		if @review.save
        	review = contract_instance.transact_and_wait.add_review(@product.product_blockchain_id,@review.rating) rescue nil
			redirect_to request.referer, notice: "Review Posted."
        else
			redirect_to request.referer, alert: @review.errors.full_messages
        end      
	end

	def get_vote_for_review
		review = Review.find_by(id: params[:id])
		vote = Vote.find_or_create_by(user_id: current_user.id, review_id: params[:id])
		vote.update(vote_status: params[:status] == "like" ? true : false)

		if params[:status] == "like"
			render json: {status: true, like_count: review.votes.where(vote_status: true).count,dislike_count: review.votes.where(vote_status: false).count}
		else
			render json: {status: false, like_count: review.votes.where(vote_status: true).count,dislike_count: review.votes.where(vote_status: false).count}
		end

	end

	def review_chart
		get_expert_average params[:product_id]
		get_normal_average params[:product_id]
    	
    	#---------------- Star Rating -------------------
    	@normal_detail = Product.find(params[:product_id])
    	@expert_detail = Product.find(params[:product_id])
	    normal_user = 'Normal User'
	    expert_user = 'Expert User'
	    @normal_detail.user_type = normal_user
	    @expert_detail.user_type = expert_user
	    @normal_detail = @normal_detail.as_json(methods: [:average_criteria_by_product, :average_criteria_by_category, :average_criteria_by_sub_cat])
	    @expert_detail = @expert_detail.as_json(methods: [:average_criteria_by_product, :average_criteria_by_category, :average_criteria_by_sub_cat])
	    @normal_detail["user_type"] = normal_user
	    @expert_detail["user_type"] = expert_user
    	#---------------- Star Rating -------------------
		
    	@normal_chart_data = []
    	@normal_chart_cat = []

    	@expert_chart_data = []
    	@expert_chart_cat = []

    	@normal_chart_cat = @normal_detail["average_criteria_by_category"].keys
		@normal_chart_data =[{name: @normal_detail["product_name"], data: @normal_detail["average_criteria_by_product"].values}, 
			{name: @normal_detail["sub_category_name"], data: @normal_detail["average_criteria_by_sub_cat"].values},
			{name: @normal_detail["category_name"], data: @normal_detail["average_criteria_by_category"].values}]
	
		@expert_chart_cat = @expert_detail["average_criteria_by_category"].keys
		@expert_chart_data =[{name: @expert_detail["product_name"], data: @expert_detail["average_criteria_by_product"].values}, 
			{name: @expert_detail["sub_category_name"], data: @expert_detail["average_criteria_by_sub_cat"].values},
			{name: @expert_detail["category_name"], data: @expert_detail["average_criteria_by_category"].values}]
	end
	private
	def require_params
		params.permit(:spoiler).merge(comment: params[:description], criteria: criteria_params,rating: params[:numeric_rating],user_id: current_user.id)
	end

	def criteria_params
		criteria = {}
		criteria_arr = @product&.category&.review_parts.pluck(:criteria)
		params_data_data = params[:rating][0]
		criteria_arr.each do |c|
			criteria[c.to_sym] = params_data_data[c.to_sym].present? ? params_data_data[c.to_sym].to_i : 0 
		end
		criteria
	end
end
