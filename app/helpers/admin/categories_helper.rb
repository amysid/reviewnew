module Admin::CategoriesHelper
	def category
		@category = Category.all
	end

	def sub_category
		@sub_category = SubCategory.all
	end
end
