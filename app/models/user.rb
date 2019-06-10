class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  enum role: ["admin","user","expert"]
  has_one :image,class_name: 'Image',as: :imageable,autosave: true,dependent: :destroy
  accepts_nested_attributes_for :image
  validates :mobile_no, uniqueness: true


  def self.to_csv(options = {})
  CSV.generate(options) do |csv|
  	cols = ["id","name", "email", "c_code", "mobile_no","created_at"]
    csv << cols
    all.each do |product|
      csv << product.attributes.values_at("id","name", "email", "c_code", "mobile_no", "created_at")
     end
    end
  end


end
