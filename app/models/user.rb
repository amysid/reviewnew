class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :lockable, :trackable
  enum role: ["admin","user","expert"]
  has_one :image,class_name: 'Image', as: :imageable, autosave: true, dependent: :destroy
  accepts_nested_attributes_for :image
  # validates :mobile_no, uniqueness: true
  validates :name, length: { minimum: 2, maximum: 20}
  # validates :mobile_no, length: { minimum: 7, maximum: 14}



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
