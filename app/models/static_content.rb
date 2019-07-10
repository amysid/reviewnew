class StaticContent < ApplicationRecord
	  validates :title, length: { minimum: 8, maximum: 25}
	  validates :description, length: {minimum: 10}
end
