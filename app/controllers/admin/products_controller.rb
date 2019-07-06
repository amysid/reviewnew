class Admin::ProductsController < ApplicationController
	before_action :authenticate_user!	
    layout 'admin_lte_2'

    def index
    end

    def new
    end

    def create
      # binding.pry
      @products = PostDetail.create(post_params)
      if @products.save
         redirect_to admin_products_path
         flash[:notice] = "product created succesfull"
       else
       	  redirect_to new_admin_product_path
       	  flash[:notice] = "product not created" 
       end

    end

    def sub_categories_by_category
    	# binding.pry
     @sub_category=Category.find_by(id: params[:id]).sub_categories
    end
 
 private
 def post_params
 	params.require(:post_detail).permit(:category, :sub_category, :product_name, :image, :video, :date, :description )
 end

end
