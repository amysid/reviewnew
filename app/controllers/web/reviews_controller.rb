class Web::ReviewsController < ApplicationController
	include CommonConcern
	def get_reviews
		@product =  Product.find_by(id: params[:id])
		@review = @product.reviews.new(require_params)
		if @review.save
        	binding.pry
        	review = contract_instance.transact_and_wait.add_review(@product.product_blockchain_id,@review.rating) rescue nil
			Blockchain.create!(mined: review.as_json["mined"], connection: review.as_json["connection"],blockchain_hash: review.as_json["id"],product_blockchain_id: review.as_json["input_parameters"][0],rating: review.as_json["input_parameters"][1], product_id: params[:id], user_id:  current_user.id)
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

	def average_criteria
  		@user_type = params[:user_type].split(' ')[0]
    	@detail = Product.find(params[:product_id])
	    user_type = params[:user_type] #'Normal User' 'Normal User'
	    @detail.user_type = user_type
	    @detail = @detail.as_json(methods: [:average_criteria_by_product, :average_criteria_by_category, :average_criteria_by_sub_cat])
	    @detail["user_type"] = user_type
    	@chart_data = []
    	@chart_cat = []
    	@chart_cat = @detail["average_criteria_by_category"].keys
		@chart_data =[{name: @detail["product_name"], data: @detail["average_criteria_by_product"].values}, 
			{name: @detail["sub_category_name"], data: @detail["average_criteria_by_sub_cat"].values},
			{name: @detail["category_name"], data: @detail["average_criteria_by_category"].values}]
	end

	def review_chart
	end

	def average_bar_graph_data
  		@user_type = params[:user_type].split(' ')[0]
  		user_type = params[:user_type]
		get_expert_average params[:product_id] , user_type
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
