class Review < ApplicationRecord
  belongs_to :product
  has_many :votes, dependent: :destroy
end
