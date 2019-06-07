class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images, id: :uuid do |t|
      t.string :file
      t.string :file_type,default: ''
      t.string :imageable_id, type: :uuid
      t.string :imageable_type
      t.timestamps
    end
  end
end
