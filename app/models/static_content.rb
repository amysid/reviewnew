class StaticContent < ApplicationRecord
	  validates :title, length: { minimum: 5, maximum: 64}
	  validates :description, length: {minimum: 10, maximum: 100000}
end
