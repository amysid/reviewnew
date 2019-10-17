class Admin::CategoriesController < ApplicationController
 before_action :authenticate_user!
 before_action :find_category, only: [:show,:edit,:update,:status,:destroy]
 layout 'admin_lte_2'

 def index
    @s_no = 0
    if params[:search].present?
       @categories = Category.where(category_name: params[:search])
       @categories = @categories.order("created_at desc").paginate(:page => params[:page], :per_page => 100)
    else
        @categories = Category.all
        @categories = @categories.order("created_at desc").paginate(:page => params[:page], :per_page => 8)
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
         # binding.pry
          contract_instance.transact.add_category(@category.category_name,@category.id) rescue nil
           redirect_to admin_categories_path, notice: 'Category Created Successfully.'
        else
           flash[:alert] = @category.errors.full_messages
           render :new
           flash[:notice] = "Category is not Create"
        end
      end
  end   

  def edit
   
    @s_no = 0

     if params[:search].present?
       @search = @category.sub_categories.where(sub_category_name: params[:search]).order("created_at desc").paginate(:page => params[:page], :per_page => 100)
       @search1 = @category.review_parts.where(criteria: params[:search]).order("created_at desc").paginate(:page => params[:page], :per_page => 100)
     else
        @search = @category.sub_categories.order("created_at desc").paginate(:page => params[:page], :per_page => 12)
        @search1 = @category.review_parts.order("created_at desc").paginate(:page => params[:page], :per_page => 12)
        
      
    end
    @sub_category = @search 
    @review_parts1 = @search1

  end

 

  

  def update
    if Product.where(category_id: params[:id]).present?
    Product.where(category_id: params[:id]).update(category_name: params[:category][:category_name])
  end
    if @category.update_attributes(category_params)
       redirect_to admin_categories_path, notice: 'Category updated Successfully.'
    else
       flash[:alert] = @category.errors.full_messages
       render 'edit'
       flash[:notice] = "Category is not update."
    end
  end

  def create_post_review
    
     @review_parts = ReviewPart.where(criteria: params[:review_parts][:criteria], category_id: params[:review_parts][:category_id])
     if @review_parts.present?
        flash[:notice] = "Review part criteria already exists"
      else
     @category=Category.find(params[:review_parts][:category_id])
    if a = @category.review_parts.create(review_part_params)
      contract_instance.transact.add_criteria(params[:review_parts][:category_id],params[:review_parts][:criteria],a.id)
      flash[:notice] = "Review Parts create successfullly"
   else
      flash[:alert] = @category.errors.full_messages
      flash[:notice] = "Unable to create review parts"
    end
  end
  redirect_to edit_admin_category_path( params[:review_parts][:category_id])
  end

  def update_review_part
   
    review_part = ReviewPart.where(criteria: params[:review_parts][:criteria], category_id: params[:review_parts][:category_id])
    @category = Category.find_by(id: params[:review_parts][:category_id])
    @review_parts = ReviewPart.find_by(id: params[:criteria_id])
    if review_part.present?
      flash[:notice] = "criteria name is already exists"
    else
      if @review_parts.update(review_part_params)
         flash[:notice] = "criteria update successfullly"
      else
       flash[:alert] = @review_parts.errors.full_messages 
       flash[:notice] = "criteria is not update"
     end
    end
    redirect_to edit_admin_category_path( params[:review_parts][:category_id])
  end

  def destroy_review_part
    
  @review_parts =  ReviewPart.find_by(id: params[:id])
  @review_parts&.destroy
  redirect_to admin_categories_path, notice: "Criteria deleted successfully"
  end
 
 def edit_review_part
 
  @review_parts = ReviewPart.find_by(id: params[:id])
 end
  def create_sub_category
    sub_category = SubCategory.where(sub_category_name: params[:sub_categories][:sub_category_name], category_id: params[:sub_categories][:category_id])
    @category = Category.find( params[:sub_categories][:category_id])
    if sub_category&.present?
      flash[:notice] = "sub category already exists."
    else
      if @category.sub_categories.create(sub_category_params)
        flash[:notice] = "sub category created successfullly."
     else
        flash[:alert] = @category.errors.full_messages
        flash[:notice] = "Unable to create sub category."
      end
    end
     redirect_to edit_admin_category_path(params[:sub_categories][:category_id])
  end


  def edit_sub_category
     
     @sub_categories = SubCategory.find_by(id: params[:id])

  end


  def update_sub_category
   
    sub_category = SubCategory.where(sub_category_name: params[:sub_categories][:sub_category_name], category_id: params[:sub_categories][:category_id])
    @category = Category.find( params[:sub_categories][:category_id])
     @sub = SubCategory.find_by(id: params[:subcat_id])
     if sub_category.present?
      flash[:notice] = "sub category already exists."
    else
      if Product.where(sub_category_id: params[:subcat_id]).present?
        Product.find_by(sub_category_id: params[:subcat_id]).update(sub_category_name: params[:sub_categories][:sub_category_name])  
     end
    if @sub.update(sub_category_params)
       flash[:notice] = "sub category update successfullly."
      else
        flash[:alert] = @sub.errors.full_messages
        flash[:notice] = "sub category is not update"
      end
    end
    redirect_to edit_admin_category_path(params[:sub_categories][:category_id])
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

  def review_part_params
    params.require(:review_parts).permit(:criteria, :category_id)
  end
  
end
