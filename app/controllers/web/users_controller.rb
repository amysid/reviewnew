class Web::UsersController < ApplicationController
  before_action :authenticate_user!, only: [:movie_category_detail,:user_profile]

  def header_search
    # binding.pry
    @trending_products =  Product.where("product_name ILIKE ?", "%#{params[:search]}%").paginate(:page => params[:page], :per_page => 10)

  end

  def read_full_review
    @review = Review.find_by(id: params[:id])
  end
  def full_review
    @review = Review.find_by(id: params[:id])
  end

  def rating_product
    # binding.pry
    @a = Product.find_by(id: params[:id])&.sub_category_id
    @sub_categories = SubCategory.find_by(id: @a)
    # @reviews=Product.find_by(id: params[:id]).reviews

    @product = Product.find_by(id: params[:id])
    @reviews_with_users = Review.new.reviews_join_user_where_product_id_is @product.id
    @reviews_normal = @reviews_with_users.where("users.user_type = ? ", "Normal User").paginate(:page => params[:page], :per_page => 10)

    @review_expert = @reviews_with_users.where("users.user_type = ? ", "Expert User").paginate(:page => params[:page], :per_page => 10)

  end

  def index
    # binding.pry
    if (current_user.present? && current_user.role == "admin")
      redirect_to admin_home_index_path(current_user)
    end

    @reviews = Review.all
    @products = Product.all

    if params[:only] == "data" && params[:id].present? && Category.find_by(id: params[:id]).present?
      category1 = Category.find_by(id: params[:id])
      @reviews_normal=  @reviews.where(user_id: User.where(user_type: "Normal User").ids, product_id: category1.product.ids).last(4)
      @review_expert =  @reviews.where(user_id: User.where(user_type: "Expert User").ids, product_id: category1.product.ids).last(4)
    else

      @category = Category.all
      @reviews_count = @products.all.map {|x| x.reviews.map.with_index {|b,index|}.count}.sum
      @average_review =  @reviews.average(:rating).to_f * 10

      # @reviews_all = Product.all.map {|x| x.reviews.map {|b| b.rating}.sum}.sum
      if params[:name].present?
        # @name1=Category.find(category_name:  params[:name])
        @name1= params[:name]
        @trending_products = @products.where(trending: true,category_name: @name1)
        @publishs = @products.published_products.where(category_name:  params[:name]) #Product.where(category_name:  params[:name],current: "publish")
        @upcomeing_products = @products.where(category_name: @name1)
        #@publishs = Product.all.where(current: "publish")


        # @products = @products.where(category_id: params[:id])
        @latest_stories =  @products.where(category_name:  params[:name]).select('products.* ,product_name,description,date, (avg(reviews.rating) *10) as avg_rating').group('id').joins(:reviews).order('avg(reviews.rating) desc').to_a
        @products =@products.where(category_name:  params[:name]).select('products.* ,product_name,description,date,products.updated_at, (avg(reviews.rating) * 10) as avg_rating').group('id').joins(:reviews).order('products.updated_at desc').to_a
      else
        @trending_products = @products.where(trending: true)
        @upcomeing_products = @products.where(['date > ?', DateTime.now] )
        @publishs = @products.published_products #Product.all.where(current: "publish")

        # @products = Product.all
        @products = @products.select('products.* ,product_name,description,date,products.updated_at, (avg(reviews.rating) * 10) as avg_rating').group('id').joins(:reviews)
        @latest_stories = @products.order('avg(reviews.rating) desc').to_a
        #@products.select('products.* ,product_name,description,date, (avg(reviews.rating) * 10) as avg_rating').group('id').joins(:reviews).order('avg(reviews.rating) desc').to_a
        @products = @products.order('products.updated_at desc').to_a
      end
      # @users = User.where(user_type: "Normal User")
      # binding.pry
      @recent_reviews =  @reviews.order("created_at DESC").limit(4)
      @todays_review =  @reviews.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day).order("created_at DESC").limit(4)
      @latest_review =  @reviews.last
      # @reviews_expert = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Expert User"}.last(4)

      # if
      # else
      # binding.pry
      @reviews_normal = Review.normal_review.limit(4)
      @review_expert = Review.expert_review.limit(4)
      # @reviews_normal = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Normal User"}.last(4)
      # @review_expert = Review.all.select{|x| x if User.find_by(id: x.user_id ).user_type == "Expert User"}.last(4)
      # end

      @rec = {}
      Category.all.each do |cat|
        cat.product.each do |pro|
          if pro.reviews.present?
            @rec[cat&.category_name] = [pro&.image&.first&.file&.url,pro.id]
            break
          end
        end
      end

    end
    # @rec = Category.joins("LEFT JOIN products on categories.id = products.category_id INNER JOIN reviews ON products.id=reviews.product_id INNER JOIN images on images.imageable_id=products.id::varchar AND images.imageable_type='Product'").select('DISTINCT categories.category_name,categories.id, products.id AS prodct_id, images.id AS image_id').uniq[0].image_id
    params.delete(:id)
    # url_for(params.except(:id))
    # url_for(url_for)

    respond_to do |format|
      format.html
      format.js
    end


  end

  def movie_category
    arr1=[]
    arr2=[]
    @products =  Product.where(sub_category_id: params[:id])
    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
    @products_movie_category = @sub_category.products.last(4)
    @products.each{|x| arr1<<x.image.headers_image }
       @banners=arr1.flatten
   # @products.each{|x| arr2<<x.image.headers_image }
   #    @Avatars=arr2.flatten
  end

  def movie_category_detail
    @sub_category = SubCategory.find_by(id: params[:id])
    @all_sub_category = @sub_category&.category&.sub_categories
    @products = @sub_category.products
    @productss = Product.last(4)
  end

  def movie_detail
    # redirect_to root_path, notice: "Review Posted."
    @a = Product.find_by(id: params[:id])&.sub_category_id
    @sub_categories = SubCategory.find_by(id: @a)
    @products_movie_details = @sub_categories&.products&.last(4)
    #  @product = Product.find_by(id: params[:id])
    #  @all_sub_category = @product&.category&.sub_categories
    #  total_review = @product.reviews.pluck(:rating).sum
    #  @user_review = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}
    # # binding.pry
    #  @meta_review = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}
    #  @user1=@user_review.pluck(:rating).sum
    #  @meta1=@meta_review.pluck(:rating).sum
    #  if (@meta_review.count)>0 && @meta_review.present?
    #  @meta_reviews_avg = @meta1/@meta_review.count
    #  else
    #  @meta_reviews_avg =0
    #  end
    #  if (@user_review.count)>0 && @user_review.present?
    #    @user_reviews_avg = @user1/@user_review.count
    #  else
    #  @user_reviews_avg =0
    #  end
    # @b = Product.find_by(id: params[:id]).sub_category_id
    # @sub_categories_movies_reviews = SubCategory.find_by(id: @b)
    # @product_moview_reviews = @sub_categories_movies_reviews.products.last(4)

    @product = Product.find_by(id: params[:id])
    @product_links=@product.product_links
    # binding.pry
    @banners = @product.image.headers_image
    @images = @product.image.images
    @all_sub_category = @product&.category&.sub_categories
    @review_parts = Product.find_by(id: params[:id])&.category&.review_parts
    @todays_review = @product.reviews.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day)

    @reviews_with_users = Review.new.reviews_join_user_where_product_id_is @product.id
    @user_reviewss = @reviews_with_users.where("users.user_type = ? ", "Normal User")
    @meta_reviewss = @reviews_with_users.where("users.user_type = ? ", "Expert User")
    @user_reviews = @user_reviewss.first(4)
    @meta_reviews = @meta_reviewss.first(4)
    @user_reviews_avg = @user_reviewss.average(:rating).to_f.round(0)
    @meta_reviews_avg = @meta_reviewss.average(:rating).to_f.round(0)
    # @user_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}.last(4)
    # @meta_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}.last(4)
    #  @user_reviewss = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}
    # @meta_reviewss = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}

    # @user_reviews_hash = {}
    # @user_reviews_hash[:positive] = []
    # @user_reviews_hash[:negative] = []
    # @user_reviews_hash[:middle] = []


    # @user_reviews.each do |r|
    #   if r&.spoiler == true
    #     @user_reviews_hash[:negative] << r
    #     next
    #   end

    #   if r&.rating >= 6
    #     @user_reviews_hash[:positive] << r
    #   elsif r&.rating < 6 && r&.rating > 3
    #       @user_reviews_hash[:middle] << r
    #     else
    #       @user_reviews_hash[:negative] << r
    #     end
    # end

    #  @meta_reviews_hash = {}
    # @meta_reviews_hash[:positive] = []
    # @meta_reviews_hash[:negative] = []
    # @meta_reviews_hash[:middle] = []


    # @meta_reviews.each do |r|
    #   if r&.spoiler == true
    #     @meta_reviews_hash[:negative] << r
    #     next
    #   end

    #   if r&.rating >= 6
    #     @meta_reviews_hash[:positive] << r
    #   elsif r&.rating < 6 && r&.rating > 3
    #       @meta_reviews_hash[:middle] << r
    #     else
    #       @meta_reviews_hash[:negative] << r
    #     end
    # end

    @user_score = {}

    @user_score[:positive] = @user_reviewss.positive_review #((@user_reviews_hash[:positive].count * 100)/@user_reviews.count) rescue 0
    @user_score[:negative] = @user_reviewss.negative_review # ((@user_reviews_hash[:negative].count * 100)/@user_reviews.count) rescue 0
    @user_score[:middle] = @user_reviewss.middle_review #((@user_reviews_hash[:middle].count * 100)/@user_reviews.count) rescue 0

    @meta_score = {}
    @meta_score[:positive] = @meta_reviewss.positive_review #((@meta_reviews_hash[:positive].count * 100)/@meta_reviews.count) rescue 0
    @meta_score[:negative] = @meta_reviewss.negative_review #((@meta_reviews_hash[:negative].count * 100)/@meta_reviews.count) rescue 0
    @meta_score[:middle] = @meta_reviewss.middle_review #((@meta_reviews_hash[:middle].count * 100)/@meta_reviews.count) rescue 0

  end

  def movie_review
    @b = Product.find_by(id: params[:id]).sub_category_id
    @sub_categories_movies_reviews = SubCategory.find_by(id: @b)
    @product_moview_reviews = @sub_categories_movies_reviews.products.last(4)
    @product = Product.find_by(id: params[:id])
    @all_sub_category = @product&.category&.sub_categories
    @review_parts = Product.find_by(id: params[:id])&.category&.review_parts
    @todays_review = @product.reviews.where(created_at: DateTime.now.beginning_of_day..DateTime.now.end_of_day)
    @user_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}.last(4)
    @meta_reviews = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}.last(4)
    @user_reviewss = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Normal User"}
    @meta_reviewss = @product.reviews.select{|review| review if User.find_by(id: review&.user_id)&.user_type == "Expert User"}

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
    @categorys = Category.all.order('created_at ASC')
    # @all_reviews = Review.where(user_id: current_user.id).select('rating,id,product_id')
    # @products = Product.where(id: @all_reviews.pluck(:product_id)) rescue []

    @all_reviews = Review.where(user_id: current_user.id).select('rating,id,product_id')
    @products =  Product.where(id: @all_reviews.pluck(:product_id),category_id: @categorys&.first&.id) rescue []

    @total_products = @products.joins("INNER JOIN reviews ON products.id = reviews.product_id AND reviews.user_id='#{current_user.id}'").select('products.id,product_name , description, date,reviews.comment AS reviews_comments, reviews.rating,reviews.id AS review_id') rescue []

    # @total_products = @products.joins(:reviews).where("products.category_id = ? AND reviews.user_id = ? ", params[:id],current_user.id)
  end

  def holl_of_fame_details
    a=[]
    Product.all.each{|x| a<<x.id if x.video.present?}
    @products=Product.where(id: a)
    @categorys = Category.all
  end

  def hollframe
    a=[]
    Product.where(category_id: params[:id]).each{|x| a<<x.id if x.video.present?}
    @products=Product.where(id: a)
  end

  def trending
    #binding.pry
    unless params[:format].present?
      @trending_products = Product.where(trending: true).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @trending_products = Product.where(trending: true,category_name: params[:format]).order("created_at desc").paginate(:page => params[:page], :per_page => 10)

    end
  end

  def upcomeing
    #binding.pry
    unless params[:format].present?
      @upcomeing_products = Product.where(['date > ?', DateTime.now] ).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    else
      @upcomeing_products = Product.where(category_name: params[:format]).where(['date > ?', DateTime.now] ).order("created_at desc").paginate(:page => params[:page], :per_page => 10)
    end
  end

  def categorywise
    @reviews = Category.find(params[:id]).product.first.reviews.last(4)
  end

  def user_score
    @all_reviews = Review.where(user_id: current_user.id).select('rating,id,product_id')
    @products =  Product.where(id: @all_reviews.pluck(:product_id),category_id: params[:id]) rescue []
    # @reviews_data = Review.find_by(user_id: current_user.id)
    @total_products = @products.joins("INNER JOIN reviews ON products.id = reviews.product_id AND reviews.user_id='#{current_user.id}'").select('products.id,product_name , description, date,reviews.comment AS reviews_comments, reviews.rating,reviews.id AS review_id') rescue []

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
    @products = Product.all
  end
  def report_details
    # binding.pry
    product_ids=[]
    Review.all.each{|x| product_ids<<x.product_id}
    @products = Product.where(id: product_ids.uniq).paginate(:page => params[:page], :per_page => 10)
  end
  def profile

  end

  def rating_calculate

  end


end
