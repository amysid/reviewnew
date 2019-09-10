class Review < ApplicationRecord
  belongs_to :product
  has_many :votes, dependent: :destroy
  belongs_to :user

  validates :user_id, uniqueness: { scope: :product_id , message: "review already exist." }
  scope :expert_review , -> { where(user_id: User.expert_user).order("created_at desc") }
  scope :normal_review , -> { where(user_id: User.normal_user).order("created_at desc") }


  def reviews_join_user_where_product_id_is product_id
  	Review.joins("INNER JOIN users on reviews.user_id = users.id").where(product_id: product_id).distinct.select("reviews.*,users.name, users.user_type").order("created_at desc")
  end

  def self.positive_review
  	@optimize_percentage.call (where("rating >= ? AND spoiler =? ",6, false).length.to_f / all.length).round(2)*100 rescue 0

  end

  def self.negative_review
  	@optimize_percentage.call (where("rating < ? OR spoiler =?",4 , true).length.to_f / all.length).round(2)*100 rescue 0
  end

  def self.middle_review
  	@optimize_percentage.call (where("rating BETWEEN ? and ? AND spoiler =? ",4,5 , false).length.to_f / all.length).round(2)*100 rescue 0
  end

  def self.average_reviews category_id , user_type
    # Product.joins("INNER JOIN reviews ON products.id=reviews.product_id AND products.category_id='#{category_id}' INNER JOIN users ON users.id=reviews.user_id AND users.user_type='#{user_type}'").distinct.group("products.id").select("products.id, (avg(reviews.rating)*10) as average_reviews").order("average_reviews ASC")
    Product.joins("INNER JOIN reviews ON products.id=reviews.product_id AND products.category_id='#{category_id}' INNER JOIN users ON users.id=reviews.user_id AND users.user_type='#{user_type}'").group("products.id").distinct.select("products.id, CAST((avg(reviews.rating)*10) AS INTEGER) AS average_reviews").order("average_reviews ASC")
  end
  # def optimize_percentage number
  # 	number == NAN ? 0.0 : number
  # end
  @optimize_percentage =lambda { |number|
  	number.nan? ? 0.0 : number
  }
end
