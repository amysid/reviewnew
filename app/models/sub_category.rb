class SubCategory < ApplicationRecord
	belongs_to :category
	has_many :details,autosave: true,dependent: :destroy
end
