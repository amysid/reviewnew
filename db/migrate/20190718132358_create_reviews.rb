class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews, id: :uuid do |t|
      t.integer :rating
      t.string :comment
      t.text :criteria, {}
      t.references :product, type: :uuid
      t.references :user, type: :uuid

      t.timestamps
    end
  end
end
