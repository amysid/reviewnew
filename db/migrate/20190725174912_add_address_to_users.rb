class AddAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_password, :string
    add_column :users, :account_address, :string
    add_column :users, :private_key, :string
  end
end
