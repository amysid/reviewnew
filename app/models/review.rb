class Review < ApplicationRecord
  belongs_to :product
  has_many :votes, dependent: :destroy

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

  # def optimize_percentage number
  # 	number == NAN ? 0.0 : number
  # end
  @optimize_percentage =lambda { |number|
  	number.nan? ? 0.0 : number
  }
end
