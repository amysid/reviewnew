class Product < ApplicationRecord
	mount_uploader :video, ImageUploader
	 # belongs_to :sub_category 
  #    belongs_to :category
       has_many :image, class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
end
