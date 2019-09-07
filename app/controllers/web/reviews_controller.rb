class Web::ReviewsController < ApplicationController

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
