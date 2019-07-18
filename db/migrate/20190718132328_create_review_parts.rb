class CreateReviewParts < ActiveRecord::Migration[5.2]
  def change
    create_table :review_parts, id: :uuid do |t|
      t.string :criteria
      t.references :product, type: :uuid

      t.timestamps
    end
  end
end
