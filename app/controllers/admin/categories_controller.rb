class Admin::CategoriesController < ApplicationController
 before_action :find_category, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'





  def index
   @categories = Category.all
  end
  
  def destroy
   @country = Country.find(params[:id])
   @country.destroy
   redirect_to admin_countries_path, notice: "Country  deleted successfully"
  end



	def new
	end

	def create
        @category = Category.create(category_params)
        if @category.save
           redirect_to admin_categories_path, notice: 'Category Created Successfully.'
        else
           flash[:notice] = @category.errors.full_messages.first
           render :new
        end
  end   

  def edit
    @sub_category = @category.sub_categories
  end

  def update
    binding.pry
  

  end

  def create_sub_category
    binding.pry
  end


  def edit_sub_category
    binding.pry
  end

  def update_sub_category
   binding.pry
  end
  
  def destroy_sub_category
   binding.pry
   
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
   params.require(:sub_category).permit(:sub_category_name, :category_id)
  end
  
end
