class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable, :omniauthable, omniauth_providers: [:facebook]
  enum role: ["admin","user","expert"]
  has_one :image,class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :image
 validates :mobile_no, uniqueness: true,  on: :update
 validates :name, length: { minimum: 2, maximum: 20}
 validates :name, format: { with: /[a-zA-Z]/, message: "%{value} not accecpt. Only allows character" }
 validates :mobile_no, numericality: { message: "%{value} seems wrong. Accecpt only Integer" },  on: :update
 validates :mobile_no, length: { minimum: 7, maximum: 14},  on: :update


  def self.to_csv(options = {})
  CSV.generate(options) do |csv|
  	cols = ["id", "name", "email", "c_code", "mobile_no", "created_at"]
    csv << cols
    all.each do |product|
      csv << product.attributes.values_at("id","name", "email", "c_code", "mobile_no", "created_at")
     end
    end
  end

  class << self
    def import(file)
      case File.extname(file.original_filename)
      when ".csv" then User.import_csv file
      when ".xls" then User.import_xls file
      when ".xlsx" then User.import_xlsx file
      else return
      end
    end

    def import_xls file
      Roo::Excel.new(file.path).each_with_index(name: "name",price: "price") do |a,index|
        next if index.eql?(0)
        User.create! a
      end
    end
    
    def import_csv file
      CSV.foreach(file.path, headers: true) do |row|
        User.create! row.to_hash 
      end
    end
    def import_xlsx file
      Roo::Excelx.new(file.path).each_with_index(name: "name",price: "price") do |a,index|
        next if index.eql?(0)
        User.create! a
      end
    end
  end

  def self.find_or_create_from_auth_hash(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
  
       user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.first_name || auth.info.name 
      # user.last_name = auth.info.last_name
       user.email = auth.info.email
      # user.remote_avatar_url = auth.info.image
      # user.user_role.name = "User"
       user.password = SecureRandom.urlsafe_base64
       user.skip_confirmation!
      user.save(validate: false)
      image = Image.new(imageable_id: user.id,imageable_type: "User")
      image.remote_file_url = "https://www.jewelinfo4u.com/images/Gallery/ruby.jpg"
      image.save
    end
  end

  # def update_with_password(params={})
  #   binding.pry
  #       current_password = params.delete(:current_password)

  #       if params[:password].blank?
  #         params.delete(:password)
  #         params.delete(:password_confirmation) if params[:password_confirmation].blank?
  #       end 

  #       result = if valid_password?(current_password)
  #         update_attributes(params)
  #       else
  #         self.attributes = params
  #         self.valid?
  #         self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
  #         false
  #       end 

  #       clean_up_passwords
  #       result
  #     end
  
end
