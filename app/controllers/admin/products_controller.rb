class Admin::ProductsController < ApplicationController
	before_action :authenticate_user!	
  before_action :find_products, only: [:show, :edit, :update, :destroy] 
  layout 'admin_lte_2'

    def index
      @s_no = 0
      if params[:search].present?
        # @products = Product.where(["product_name = ? OR category = ? OR sub_category = ?", params[:search], params[:search], params[:search]])
         @products = Product.where(["product_name = ? OR category_name = ? OR sub_category_name = ?", params[:search], params[:search], params[:search]])
         @products = @products.order("created_at desc").paginate(:page => params[:page], :per_page => 100)
      else
      @products = Product.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
      @category = Category.all
      end
    end

    def new
      @products = Product.new
      @products.image&.build
    end

    def show
     @images = @products.image.all
      @category=Category.find(@products.category_id)
    @sub_category=SubCategory.find(@products.sub_category_id)
    end
     
    def edit
    @images = @products.image.all
    @sub_categories =@products.category.sub_categories.pluck("sub_category_name")
    end

    def create
      @products = Product.new(product_params)
      @products.category_id = Category.find_by(category_name: params[:product][:category_name]).id
      @products.sub_category_id = SubCategory.find_by(sub_category_name: params[:product][:sub_category_name]).id
      if params[:product][:date].present?
      x=params[:product][:date][0,2]
      params[:product][:date][0,2]= params[:product][:date][3,2]
      params[:product][:date][3,2]=x
      @products.date = params[:product][:date]
      end
      if @products.save
        contract_instance.transact_and_wait.add_product(@products.product_name)
         redirect_to admin_products_path(@products)
         flash[:notice] = "product created succesfull"
       else
          flash[:alert] = @products.errors.full_messages
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
      # binding.pry
      @products.update(category_id: Category.find_by(category_name: params[:product][:category_name]).id)
      @products.update(sub_category_id: SubCategory.find_by(sub_category_name: params[:product][:sub_category_name]).id)
      if params[:product][:date].size == 10
      x=params[:product][:date][0,2]
      params[:product][:date][0,2]= params[:product][:date][3,2]
      params[:product][:date][3,2]=x
      @products.date = params[:product][:date]
    else
      @products.date = params[:product][:date]
    end
        if @products.update_attributes(product_params)
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
 
   def publish
    Product.find_by(id: params[:id]).update(current: "unpublish")
    redirect_to admin_products_path
      flash[:notice] = "Unpublish mode Successfully"
   end

   def unpublish
    Product.find_by(id: params[:id]).update(current: "publish")
    redirect_to admin_products_path
    flash[:notice] = "Publish mode Successfully"
   end

   def trending
   # binding.pry
   @trending=Product.find_by(id: params[:id]).trending
   if @trending == true
     Product.find_by(id: params[:id]).update(trending: false)
      redirect_to admin_products_path
     flash[:notice] = "Product is not trending"
    else
     Product.find_by(id: params[:id]).update(trending: true)
      redirect_to admin_products_path
     flash[:notice] = "Product is trending"
   end
 end

 private
 def product_params 
  # params[:product][:date] = params[:product][:date]
 	params.require(:product).permit(:category_name, :sub_category_name, :product_name, :video, :date, :description, image_attributes: [:id, :file, :_destroy])
 end
 # def update_product 
 #  params.require(:products).permit(:category, :sub_category, :product_name, :video, :description, image_attributes: [:id, :file, :_destroy])
 # end
 def find_products
    @products = Product.find_by(id: params[:id])
    redirect_to admin_products_path unless @products
 end
end
