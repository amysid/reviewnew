class Admin::CategoriesController < ApplicationController
 before_action :find_category, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'

	def new
      @category = Category.new
      @category.sub_categories.build		
	end

	def create
    binding.pry
        @category = Category.create(category_params)
        if @category.save
           redirect_to admin_categories_path, notice: 'Category Created Successfully.'
        else
           flash[:notice] = @category.errors.full_messages.first
           render :new
        end
  end

  private
  def find_category
	     @category = Category.find_by(id: params[:id])
	     redirect_to admin_categories_path unless @category
  end
  def category_params
	    params.require(:category).permit(:category_type, sub_categories_attributes: [:category_id, :sub_category_type, :_destroy])
  end
end
