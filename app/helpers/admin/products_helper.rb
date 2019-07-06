module Admin::ProductsHelper
	def all_category
		Category.all.pluck("category_name")
	end
	def all_sub_category
		SubCategory.all.pluck("sub_category_name")
	end
end
