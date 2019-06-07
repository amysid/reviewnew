class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :password
      t.string :c_code
      t.string :mobile_no
      t.string :access_token
      t.string :reset_token
      t.string :fb_id
      t.integer :role
      t.boolean :status
      t.boolean :confimed
      t.datetime :reset_token_send_at

      t.timestamps
    end
  end
end
