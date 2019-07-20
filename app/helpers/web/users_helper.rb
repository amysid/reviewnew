module Web::UsersHelper

	def category
		Category.all
	end

	def trending
		Product.where(trending: true)
	end

	def user_name id
		User.find_by(id: id)&.name
	end

	def user_image id
		User.find_by(id: id)&.image
	end

	def meta_review(product)
		status = false
			product.reviews.each do |review|
				status = true if User.find_by(id: review&.user_id)&.user_type == "Expert User"
				break if status
			end
		status
	end
end