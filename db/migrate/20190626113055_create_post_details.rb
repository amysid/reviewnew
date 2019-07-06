class CreatePostDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :post_details, id: :uuid do |t|
      t.integer :rate_count
      t.integer :review_count
      t.string :category,     null: false, default: ""
      t.string :sub_category, null: false, default: ""
      t.string :product_name, null: false, default: ""
      t.date   :date
      t.string :image,        null: false, default: ""
      t.string :video,        null: false, default: ""
      t.string :description,  null: false, default: ""
      t.string :comment,      null: false, default: ""
      t.references :sub_category, foreign_key: true, type: :uuid
      t.references :category, froegin_key: true, type: :uuid

      t.timestamps
    end
  end
end
