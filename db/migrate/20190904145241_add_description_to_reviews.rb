class AddDescriptionToReviews < ActiveRecord::Migration[5.2]
  def change
  	add_column :reviews, :comment_desc, :text
  end
end
