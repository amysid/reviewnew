module Admin::ProductsHelper
	def all_category
		Category.all.pluck("category_name")
	end
	def all_sub_category
		SubCategory.all.pluck("sub_category_name")
	end

	 def sub_categories_by_category
	 	binding.pry
	 	product =Category.find_by(category_name: params[:id]).sub_categories
	 end
end
