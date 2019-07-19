class Category < ApplicationRecord
	has_many :sub_categories,autosave: true, dependent: :destroy
	has_many :product, dependent: :destroy
	has_many :review_parts, dependent: :destroy
	# accepts_nested_attributes_for :sub_categories, allow_destroy: true
validates :category_name, length: { minimum: 2, maximum: 25}
end
