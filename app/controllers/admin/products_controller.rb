class Admin::ProductsController < ApplicationController
	before_action :authenticate_user!	
  before_action :find_products, only: [:show, :edit, :update, :destroy] 
  layout 'admin_lte_2'

    def index
      @s_no = 0
      if params[:search].present?
         @products = Product.where("product_name ILIKE ?", "%#{params[:search]}%")
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

    def add_links
       @s_no = 0
       # binding.pry
    if params[:search].present?
       @categories = Category.where(category_name: params[:search])
       @categories = @categories.order("created_at desc").paginate(:page => params[:page], :per_page => 100)
    else
        @product_links = Product.find_by(id:params[:id]).product_links
        @products_link = @product_links.order("created_at desc").paginate(:page => params[:page], :per_page => 8)
    end
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
      @products = Product.where(category_name: params[:product][:category_name], sub_category_name: params[:product][:sub_category_name], product_name: params[:product][:product_name])
      if @products.present?
         flash[:notice] = "Product name is all ready created for the same category and sub category name"
      else
      @products = Product.new(product_params)
      @products.category_id = Category.find_by(category_name: params[:product][:category_name]).id
      @products.sub_category_id = SubCategory.find_by(sub_category_name: params[:product][:sub_category_name]).id
      if params[:product][:date].present?
        x=params[:product][:date][0,2]
        params[:product][:date][0,2]= params[:product][:date][3,2]
        params[:product][:date][3,2]=x
        @products.date = params[:product][:date]
      end
      if @products.save!
        
        # productCount = 0
        contract_instance.transact_and_wait.add_product(@products.product_name,@products.category_id) rescue nil
         count = contract_instance.call.product_count - 1 rescue 0
        # productCount = Product.maximum(:product_blockchain_id) + 1 rescue 0
        @products.update!(product_blockchain_id: count)
        # productCount +=1
        redirect_to admin_products_path(@products)
        flash[:notice] = "product created succesfull"
       else
          flash[:alert] = @products.errors.full_messages
       	  redirect_to new_admin_product_path
       	  flash[:notice] = "product not created" 
       end
     end
    end
    
   def destroy
      if @products.destroy
             redirect_to admin_products_path
          else
             redirect_to admin_products_path
      end
   end

    def update
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
   
   def show_in_banner
     @show_in_banner=Product.find_by(id: params[:id]).show_in_banner
   if @show_in_banner == true
     Product.find_by(id: params[:id]).update(show_in_banner: false)
      redirect_to admin_products_path
     flash[:notice] = "Product will not show in banner"
    else
     Product.find_by(id: params[:id]).update(show_in_banner: true)
      redirect_to admin_products_path
     flash[:notice] = "Product will show in banner"
   end
   end

   def unpublish
    Product.find_by(id: params[:id]).update(current: "publish")
    redirect_to admin_products_path
    flash[:notice] = "Publish mode Successfully"
   end

   def trending
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
 
 def new_addlinks
 end

 def create_product_link
  @products=Product.find_by(id: params[:id])
  @products.product_links.create(product_link)
  redirect_to add_links_admin_product_path(params[:id])
 end

def product_link_delete
  ProductLink.find_by(id: params[:id]).destroy
  redirect_to admin_products_path
   end

 private
 def product_params 
 	params.require(:product).permit(:category_name, :sub_category_name, :product_name, :video, :date, :description, image_attributes: [:id, :file, :_destroy, :file_type,:avtar])
 end
 
 def find_products
    @products = Product.find_by(id: params[:id])
    redirect_to admin_products_path unless @products
 end
 def product_link
  params.require(:category).permit(:link,:url)
 end
end
