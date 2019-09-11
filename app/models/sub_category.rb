class SubCategory < ApplicationRecord
	belongs_to :category
	has_many :products, dependent: :destroy
	has_many :review_parts, through: :category
	validates :sub_category_name, length: { minimum: 4, maximum: 30}
	# has_many :details,autosave: true,dependent: :destroy
    # accepts_nested_attributes_for :details, allow_destroy: true
    
end	
