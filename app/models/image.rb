class Image < ApplicationRecord
  mount_uploader :file, ImageUploader
  belongs_to :imageable, polymorphic: true

  def self.headers_image
  	all.collect{|x| x.file_url if x.file_type == "1" }.compact
  end

  def self.images
  	all.collect{|x| x.file_url if x.file_type == "0" }.compact
  end
end
