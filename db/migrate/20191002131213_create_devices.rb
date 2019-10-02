class CreateDevices < ActiveRecord::Migration[5.2]
  def change
    create_table :devices, id: :uuid do |t|
      t.string :device_type
      t.string :device_token
      t.references :user, type: :uuid

      t.timestamps
    end
  end
end
