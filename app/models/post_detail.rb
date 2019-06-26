class PostDetail < ApplicationRecord
	belongs_to :sub_category 
	belongs_to :category
	has_many :image, as: :imageable, dependent: :destroy
end
