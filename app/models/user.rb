class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  enum role: ["admin","user","expert"]
  has_one :image,class_name: 'Image',as: :imageable,autosave: true,dependent: :destroy
  accepts_nested_attributes_for :image
end
