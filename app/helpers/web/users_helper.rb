module Web::UsersHelper

	def category
		Category.all
	end

	def trending
		Product.where(trending: true)
	end
end
