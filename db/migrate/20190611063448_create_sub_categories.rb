class CreateSubCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :sub_categories, id: :uuid do |t|
      t.string :sub_category_name
      t.references :category, foreign_key: true,type: :uuid
      t.timestamps
    end
  end
end
