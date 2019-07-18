class Web::UsersController < ApplicationController
  def index
     # binding.pry
  	if (current_user.present? && current_user.role == "admin")
        redirect_to admin_home_index_path(current_user)
  	end
    @category = Category.all
    # @sub_category = Category.find_by(id: params[:id])&.sub_categories
    # @sub_categories = Product.where(category_id: params[:id])
    # @trending = Product.all
    @movies = Product.where(category_name: "Movies").first(2)
    @games = Product.where(category_name: "Games").first(2)
    @tvs = Product.where(category_name: "TV").first(2)
    @products = Product.all
    @users = User.where(user_type: "Normal User")
       # @trending_image = @trending.image.all
  end

  def movie_category
    # @category = Category.all
    # @trending = Product.where(trending: true)
    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
  end

  def movie_category_detail
    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
  end

  def movie_detail    
    @product = Product.find_by(id: params[:id])
    @all_sub_category = @product&.category&.sub_categories
  end

  def movie_review
    @product = Product.find_by(id: params[:id])
    @all_sub_category = @product&.category&.sub_categories
  end
  
  def user_profile
    # binding.pry
    @categorys = Category.all
    @products = Product.all
  end
 
 def trending
 @products = Product.all
 end

 def upcomeing
  # binding.pry
  @products = Product.all
 end

  def abc
    # binding.pry
    @products = Product.where(category_id: params[:id])
  end

    def check_email
        @user = User.pluck(:email)
        if @user.include?(params[:user][:email])
          render json: false
        else
          render json: true
        end
    end

  def check_email_login
      @user = User.pluck(:email)
      if @user.include?(params[:user][:email])
        render json: true
      else
        render json: false
      end
  end

  def image_update
    if params[:file].present?
      if current_user.image.present?   
        current_user.image.update(file: params[:file])
      else
        current_user.create_image(file: params[:file])
      end
      redirect_to user_profile_web_user_path(id: current_user.id)
      flash[:notice] = "Profile updated successfully."
    end
    if params[:current_password].present?
      if params[:password].present? && params[:password_confirmation].present?
        unless params[:password] == params[:password_confirmation]
        redirect_to request.referer
        flash[:notice] = "Password didn't match with the confirmation password."
        end
        current_user.update(password: params[:password])
        redirect_to new_user_session_path
        flash[:notice] = "Password updated successfully, please sign in to continue."
      else
        redirect_to request.referer
        flash[:notice] = "Please enter new password." 
      end
    end
    
  end

  def show
  end
  
  def report
  end

  def profile
    # binding.pry
  end
  
end
