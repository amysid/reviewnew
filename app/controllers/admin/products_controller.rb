class Admin::ProductsController < ApplicationController
	before_action :authenticate_user!	
  before_action :find_products, only: [:show, :edit, :update, :destroy] 
  layout 'admin_lte_2'

    def index
      @s_no = 0
      if params[:search].present?
          @products = Product.where(product_name: params[:search])
      else
      @products = Product.all
      end
    end

    def new
       @products = Product.new
        @products.image&.build
    end

    def show
     @images = @products.image.all
      # binding.pry
    end
     
    def edit
      @images = @products.image.all
      # binding.pry
    end

    def create
      binding.pry
      @products = Product.new(product_params)
      if @products.save
         redirect_to admin_products_path(@products)
         flash[:notice] = "product created succesfull"
       else
       	  redirect_to new_admin_product_path
       	  flash[:notice] = "product not created" 
       end
     end
 
   def destroy
    # binding.pry
      if @products.destroy
             redirect_to admin_products_path
          else
             redirect_to admin_products_path
      end
   end

    def update
          binding.pry
        if @products.update_attributes(update_product)
            redirect_to admin_products_path, notice: 'Products Updated Successfully.'
          else
               flash[:notice] = @products.errors.full_messages
               render 'edit'
            end
         end

    def sub_categories_by_category
     product =Category.find_by(category_name: params[:id]).sub_categories
     render json: product
    end
 
 private
 def product_params 
 	params.require(:product).permit(:category, :sub_category, :product_name, :video, :date, :description, image_attributes: [:id, :file, :_destroy])
 end
 def update_product 
  params.require(:products).permit(:category, :sub_category, :product_name, :video, :date, :description, image_attributes: [:id, :file, :_destroy])
 end
 def find_products
    @products = Product.find_by(id: params[:id])
    redirect_to admin_products_path unless @products
 end
end
