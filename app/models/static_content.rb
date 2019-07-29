class StaticContent < ApplicationRecord
	  validates :title, length: { minimum: 5, maximum: 64}
	  validates :description, length: {minimum: 20, maximum: 1000}
end
