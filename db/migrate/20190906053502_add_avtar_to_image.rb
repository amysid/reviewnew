class AddAvtarToImage < ActiveRecord::Migration[5.2]
  def change
    add_column :images, :avtar, :boolean
  end
end
