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

	def review_vote_status(id)
		# binding.pry
		review = Review.find_by(id: id)
		# this_vote = review&.votes.where(user_id: current_user.id)&.first
		this_vote = review&.votes&.first#.where(user_id: current_user.id)&.first
        
		if this_vote.present?
			return this_vote&.vote_status
		else
			return false
		end

	end

	def review_vote_status_dislike(id)
		# binding.pry
		review = Review.find_by(id: id)
		# this_vote = review&.votes.where(user_id: current_user.id)&.first
		this_vote = review&.votes&.first#.where(user_id: current_user.id)&.first
        
		if this_vote.present?
			return this_vote&.vote_status
		else
			return true
		end

	end

	def voting_like_count(review)
		review.votes.where(vote_status: true).count
	end

	def voting_dislike_count(review)
		review.votes.where(vote_status: false).count
	end

end