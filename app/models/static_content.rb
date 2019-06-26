class StaticContent < ApplicationRecord
	  validates :title, length: { minimum: 8, maximum: 20}
	  validates :description, length: {minimum: 10}
end
