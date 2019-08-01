class Web::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:holl_of_fame_details, :movie_category_detail, :movie_review,:user_profile]
  def index
     # binding.pry
  	if (current_user.present? && current_user.role == "admin")
        redirect_to admin_home_index_path(current_user)
  	end
    @category = Category.all
    @publishs = Product.all.where(current: "publish")
    @reviews_count = Product.all.map {|x| x.reviews.map.with_index {|b,index|}.count}.sum
    @reviews_all = Product.all.map {|x| x.reviews.map {|b| b.rating}.sum}.sum
    # @movies = Product.where(category_name: "Movies").first(2)
    # @games = Product.where(category_name: "Games").first(2) 
    # @tvs = Product.where(category_name: "TV").first(2)
    @trending_products = Product.where(trending: true)
    @products = Product.all
    @latest_stories = Product.all.order("created_at desc")
    @users = User.where(user_type: "Normal User")
    @recent_reviews = Review.all.order("created_at DESC").limit(4)
    @todays_review = Review.all.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC").limit(4)
    @latest_review = Review.last
    @reviews_expert = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Expert User"}.last(4)
    
     #binding.pry
    if params[:id].present? && Category.find_by(id: params[:id]).present? # && params["id"].split('/')[1] == "nav-name"
        category1 = Category.find_by(id: params[:id])
        @reviews_normal= Review.where(user_id: User.find_by(user_type: "Normal User").id, product_id: category1.product.ids).last(4)
        @review_expert = Review.where(user_id: User.find_by(user_type: "Expert User").id, product_id: category1.product.ids).last(4)
        # binding.pry
   # elsif params[:id].present? && Category.find_by(id: params[:id]&.split('/')[0]).present? && params["id"].split('/')[1] == "nav-metascore"
   #     category1 = Category.find_by(id: params[:id]&.split('/')[0])
   #     @review_expert = Review.where(user_id: User.find_by(user_type: "Expert User").id, product_id: category1.product.ids).last(4)
    else
       @reviews_normal = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Normal User"}.last(4)
       @review_expert = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Expert User"}.last(4)
   end
    

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
    respond_to do |format|
      format.html
      format.js
    end


  end

  def movie_category
# binding.pry
    # @category = Category.all
    # @trending = Product.where(trending: true)
    @products =  Product.find_by(sub_category_id: params[:id])

    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
  end

  def movie_category_detail
    # binding.pry
    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
     @productss = Product.last(4)
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
    @user_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}.last(4)
    @meta_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}.last(4)
    
    @user_reviews_hash = {}
    @user_reviews_hash[:positive] = [] 
    @user_reviews_hash[:negative] = []
    @user_reviews_hash[:middle] = []


    @user_reviews.each do |r|
      if r&.spoiler == true
        @user_reviews_hash[:negative] << r
        next
      end

      if r&.rating >= 6
        @user_reviews_hash[:positive] << r
      elsif r&.rating < 6 && r&.rating > 3
          @user_reviews_hash[:middle] << r
        else
          @user_reviews_hash[:negative] << r
        end
    end

     @meta_reviews_hash = {}
    @meta_reviews_hash[:positive] = [] 
    @meta_reviews_hash[:negative] = []
    @meta_reviews_hash[:middle] = []


    @meta_reviews.each do |r|
      if r&.spoiler == true
        @meta_reviews_hash[:negative] << r
        next
      end

      if r&.rating >= 6
        @meta_reviews_hash[:positive] << r
      elsif r&.rating < 6 && r&.rating > 3
          @meta_reviews_hash[:middle] << r
        else
          @meta_reviews_hash[:negative] << r
        end
    end

    @user_score = {}

    @user_score[:positive] = ((@user_reviews_hash[:positive].count * 100)/@user_reviews.count) rescue 0
    @user_score[:negative] = ((@user_reviews_hash[:negative].count * 100)/@user_reviews.count) rescue 0
    @user_score[:middle] = ((@user_reviews_hash[:middle].count * 100)/@user_reviews.count) rescue 0


    @meta_score = {}

    @meta_score[:positive] = ((@meta_reviews_hash[:positive].count * 100)/@meta_reviews.count) rescue 0
    @meta_score[:negative] = ((@meta_reviews_hash[:negative].count * 100)/@meta_reviews.count) rescue 0
    @meta_score[:middle] = ((@meta_reviews_hash[:middle].count * 100)/@meta_reviews.count) rescue 0




  end
  
  def user_profile
    @categorys = Category.all
    @products = Product.all
    @total_products = Product.joins(:reviews).where("products.category_id = ? AND reviews.user_id = ? ", params[:id],current_user.id)
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
     @trending_products = Product.where(trending: true).order("created_at desc").paginate(:page => params[:page], :per_page => 5)
  end

  def upcomeing
    @upcomeing_products = Product.where(['date > ?', DateTime.now] ).order("created_at desc").paginate(:page => params[:page], :per_page => 5)
  end
  
  def categorywise
     @reviews = Category.find(params[:id]).product.first.reviews.last(4)
  end

  def user_score
   @products = Product.where(category_id: params[:id])
   @reviews_data = Review.find_by(user_id: current_user.id)
   @total_products = Product.joins(:reviews).where("products.category_id = ? AND reviews.user_id = ? ", params[:id],current_user.id)

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
    @products = Product.last(10)
  end
  def report_details
    @products = Product.order("created_at desc").paginate(:page => params[:page], :per_page => 10)
  end
  def profile
    # binding.pry
  end

  def rating_calculate
    # binding.paramsry
  end
  
end
