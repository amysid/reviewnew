class CreateProductLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :product_links, id: :uuid do |t|
      t.string :link
      t.string :url
      t.references :product, type: :uuid
      t.timestamps
    end
  end
end
