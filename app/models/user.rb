class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :trackable, :lockable

  enum role: ["admin","user","expert"]
  has_one :profile_pic,class_name: 'Image',as: :imageable,autosave: true,dependent: :destroy

end
