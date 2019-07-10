class Category < ApplicationRecord
	has_many :sub_categories,autosave: true, dependent: :destroy
	# accepts_nested_attributes_for :sub_categories, allow_destroy: true
validates :category_name, length: { minimum: 5, maximum: 25}
end
