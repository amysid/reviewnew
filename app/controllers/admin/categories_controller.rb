class Admin::CategoriesController < ApplicationController
 before_action :authenticate_user!
 before_action :find_category, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'





  def index
    # binding.pry
    @s_no = 0
    if params[:search].present?
       @categories = Category.where(category_name: params[:search])
       redirect_to admin_categories_path
       flash[:notice] = "Search Successfully"
    else
       @categories = Category.all
       # flash[:notice] = "Search not successfullly"
    end
  end

  
  
  def destroy
   @category = Category.find(params[:id])
   @category.destroy
   redirect_to admin_categories_path, notice: "Category  deleted successfully"
  end



	def new
	end

	def create
       category = Category.where(category_name: params[:category][:category_name])
       if category.present?
        flash[:notice] = "Category already exists"
        redirect_to admin_categories_path
       else
        @category = Category.create(category_params)
        if @category.save
           redirect_to admin_categories_path, notice: 'Category Created Successfully.'
        else
           flash[:notice] = @category.errors.full_messages.first
           render :new
        end
      end
  end   

  def edit
    @sub_category = @category.sub_categories
  end

  def update
  

  end

  def create_sub_category
    sub_category = SubCategory.where(sub_category_name: params[:sub_categories][:sub_category_name], category_id: params[:sub_categories][:category_id])
    @category = Category.find( params[:sub_categories][:category_id])
     
    if sub_category.present?
      flash[:notice] = "sub category already exists."
      redirect_to admin_categories_path
    else
      if @category.sub_categories.create(sub_category_params)
        flash[:notice] = "sub category created successfullly."
        redirect_to admin_categories_path
      else
        flash[:notice] = "Unable to create sub category."
        redirect_to new_admin_category_path
      end
    end
  end
  
   




  def edit_sub_category
    # binding.pry
  end

  def update_sub_category
   # binding.pry
  end
  
  def destroy_sub_category
   @sub_category = SubCategory.find(params[:id])
    @sub_category.destroy
   redirect_to admin_categories_path, notice: "Sub Category  deleted successfully"
  end


  private

  def category_params
    params.require(:category).permit(:category_name)
  end

  def find_category
    @category = Category.find_by(id: params[:id])
	  redirect_to admin_categories_path unless @category
  end

  def sub_category_params
   params.require(:sub_categories).permit(:sub_category_name, :category_id)
  end
  
end
