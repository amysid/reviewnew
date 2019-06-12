class Category < ApplicationRecord
	has_many :sub_categories,autosave: true,dependent: :destroy
	accepts_nested_attributes_for :sub_categories, allow_destroy: true

end