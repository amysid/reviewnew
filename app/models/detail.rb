class Detail < ApplicationRecord
	belongs_to :sub_category 
	# has_many :image, autosave: true,  dependent: :destroy
	has_many :image, as: :imageable, dependent: :destroy
end
