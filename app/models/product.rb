class Product < ApplicationRecord
    attr_accessor :user_type
	mount_uploader :video, ImageUploader
	# mount_uploader :file, ImageUploader
	belongs_to :sub_category 
    belongs_to :category
    has_many :product_links, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_many :image, class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
    accepts_nested_attributes_for :image, allow_destroy: true
    validates :product_name, presence: true
    validates :category_name, presence: true
    validates :product_name, length: { minimum: 3, maximum: 20}
    validates :product_name, format: { with: /[a-zA-Z]/, message: "%{value} not accecpt. Only allows character" }
    validates :description, length: { minimum: 20, maximum: 500}

    scope :published_products , -> { where(current: "publish").order("created_at DESC") }
    #validates :product_name, format: { with: /\A[a-zA-Z]+\z/, message: "%{value} not accecpt. Only allows letters" }
    def average_criteria_by_product        
        Review.average_criteria_by_product self.id , self.user_type
    end

    def average_criteria_by_category
        Review.average_criteria_by_category self.id , self.user_type
    end

    def average_criteria_by_sub_cat
        Review.average_criteria_by_product self.id , self.user_type
    end
end
