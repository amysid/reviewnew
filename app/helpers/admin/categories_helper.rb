module Admin::CategoriesHelper
	def category
		# binding.pry
		Category.all.pluck("category_type")
	end

	def sub_category
	SubCategory.all.pluck("sub_category_type")
	end
end
