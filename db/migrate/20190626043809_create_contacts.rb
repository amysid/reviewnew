class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts, id: :uuid do |t|
      t.string :name,               null: false, default: ""
      t.string :email,               null: false, default: ""
      t.string :phone_no,               null: false, default: ""
      t.string :user_feedback,               null: false, default: ""

      t.timestamps
    end
  end
end
