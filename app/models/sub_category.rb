class SubCategory < ApplicationRecord
	belongs_to :category
	has_many :details,autosave: true,dependent: :destroy
    accepts_nested_attributes_for :details, allow_destroy: true

end
