class PostDetail < ApplicationRecord
	belongs_to :sub_category 
	belongs_to :category
	has_many :images, as: :imageable, dependent: :destroy
    accepts_nested_attributes_for :images
end
