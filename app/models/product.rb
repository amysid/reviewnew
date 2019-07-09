class Product < ApplicationRecord
	mount_uploader :video, ImageUploader
	# mount_uploader :file, ImageUploader
	 # belongs_to :sub_category 
     # belongs_to :category
    has_many :image, class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
    accepts_nested_attributes_for :image, reject_if: :all_blank, allow_destroy: true
	end
