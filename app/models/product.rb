class Product < ApplicationRecord
	mount_uploader :video, ImageUploader
	# mount_uploader :file, ImageUploader
	belongs_to :sub_category 
    belongs_to :category
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
	end
