class CreateStaticContents < ActiveRecord::Migration[5.2]
  def change
    create_table :static_contents, id: :uuid do |t|
      t.string :title,default: ''
      t.text :description,default: ''

      t.timestamps
    end
  end
end
