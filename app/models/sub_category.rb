class SubCategory < ApplicationRecord
	belongs_to :category
	has_many :products, dependent: :destroy
	validates :sub_category_name, length: { minimum: 5, maximum: 25}
	# has_many :details,autosave: true,dependent: :destroy
    # accepts_nested_attributes_for :details, allow_destroy: true
    
end	
