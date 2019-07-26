class User < ApplicationRecord
  include AccountConcern
  include AuthUserConcern
  attr_accessor :key,:salt
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable, :omniauthable, omniauth_providers: [:facebook]
  enum role: ["admin","user","expert"]
  has_one :image,class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :image
 # validates :mobile_no, uniqueness: true,  on: :update
 validates :name, length: { minimum: 2, maximum: 20}
 validates :name, format: { with: /[a-zA-Z]/, message: "%{value} not accecpt. Only allows character" }
 # validates :mobile_no, numericality: { message: "%{value} seems wrong. Accecpt only Integer" },  on: :update
 # validates :mobile_no, length: { minimum: 7, maximum: 14},  on: :update

after_create :set_account 

  after_find ->{
    self.key = self.id
    self.salt = self.created_at
  }
# set ethereum account of users
  # def set_account 
  #   binding.pry
  #   data = self.u_role_before_type_cast == 0 ? "Mobiloitte1" : SecureRandom.alphanumeric(8)
  #   self.account_password = Encrypt_me.call(self.employee_login_id,self.created_at,data)
  #   self.account_address = self.u_role_before_type_cast == 0 ? Client.personal_list_accounts["result"][0] : User.get_new_address(data)
  # end

  def set_account
    unless self.role_before_type_cast == 0
      key = Eth::Key.new
      data = SecureRandom.alphanumeric(8)
      unique_id = self.id.to_s
      # default_auth_contract_instance.transact.setuser_private_key(unique_id, key.address)
      Client.personal_import_raw_key(key.private_hex,data)
      self.account_password = Encrypt_me.call(self.id,self.created_at,data)
      self.account_address = self.role_before_type_cast == 0 ? Client.personal_list_accounts["result"][0] : key.address #get_new_address(data)

      self.save
    end
  end


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
      user&.image&.destroy if user.image.present?
      image = user.create_image#Image.new(imageable_id: user.id,imageable_type: "User")
      image.remote_file_url = auth.info.image
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
