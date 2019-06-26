class CreateDetails < ActiveRecord::Migration[5.2]
  def change
    create_table :details, id: :uuid do |t|
      t.string :title,  null: false, default: ""
      t.string :description,  null: false, default: ""
      t.references :sub_category, foreign_key: true,type: :uuid

      t.timestamps
    end
  end
end
