class User < ApplicationRecord
  enum role: ["admin","user","expert"]
  has_one :profile_pic,class_name: 'Image',as: :imageable,autosave: true,dependent: :destroy

end
