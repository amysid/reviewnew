class Web::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:holl_of_fame_details, :movie_category, :movie_category_detail, :movie_detail, :movie_review,:user_profile, :hollframe, :trending, :upcomeing]
  def index
     # binding.pry
  	if (current_user.present? && current_user.role == "admin")
        redirect_to admin_home_index_path(current_user)
  	end
    @category = Category.all
    @movies = Product.where(category_name: "Movies").first(2)
    @games = Product.where(category_name: "Games").first(2) 
    @tvs = Product.where(category_name: "TV").first(2)
    @products = Product.all
    @users = User.where(user_type: "Normal User")
    @recent_reviews = Review.all.order("created_at DESC").limit(4)
    @todays_review = Review.all.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC").limit(4)
    @latest_review = Review.last
    @reviews = Review.first(4)


    @rec = {}
    Category.all.each do |cat|
      cat.product.each do |pro|
       if pro.reviews.present?
        @rec[cat&.category_name] = pro&.image&.first&.file&.url
        break
       end
      end
    end
  # @percentage = []
  # Review.all.each do |review|
  # part = eval review&.criteria
  # sum = part.values.map {|k| k.to_i}.sum
  # total = part.values.count * 5
  # @per = (sum*100)/total
  # @percentage.push(@per)
  #  # p @per
  #  end



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
    @user_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}
    @meta_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}
  end

  def movie_review
    @product = Product.find_by(id: params[:id])
    @all_sub_category = @product&.category&.sub_categories
    @review_parts = Product.find_by(id: params[:id])&.category&.review_parts
    @todays_review = @product.reviews.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
    @user_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}
    @meta_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}
  end
  
  def user_profile
    @categorys = Category.all
    @products = Product.all
  end

  def holl_of_fame_details
    @products = Product.all
    @categorys = Category.all
  end

  def hollframe
     @products = Product.where(category_id: params[:id])
  end
 
  def trending
    # binding.pry
     @trending_products = Product.where(trending: true).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end

  def upcomeing
    @upcomeing_products = Product.where(['date > ?', DateTime.now] ).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end
  
  def categorywise
     # binding.pry
     @reviews = Category.find(params[:id]).product.first.reviews
  end

  def abc
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
