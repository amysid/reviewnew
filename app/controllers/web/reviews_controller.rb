class Web::ReviewsController < ApplicationController

	def get_reviews

		@product =  Product.find_by(id: params[:id])

		rating = params[:numeric_rating].to_i
		comment = params[:description]
		params_data_data = params[:rating][0]
        spoiler = params[:spoiler].present? ? true : false
		criteria = {}

		criteria_arr = @product&.category&.review_parts.pluck(:criteria)
		criteria_arr.each do |c|
			criteria[c.to_sym] = params_data_data[c.to_sym].present? ? params_data_data[c.to_sym].to_i : 0 
		end
		@product.reviews.create(rating: rating, comment: comment, spoiler: spoiler, criteria: criteria, user_id: current_user.id)
        review = contract_instance.transact_and_wait.add_review(@product.product_blockchain_id,rating)
        p review     
        
        
		redirect_to request.referer, notice: "Review Posted."
		# @product.create_review()
	end
end
