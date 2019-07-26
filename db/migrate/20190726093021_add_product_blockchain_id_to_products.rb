class AddProductBlockchainIdToProducts < ActiveRecord::Migration[5.2]
  def change
    add_column :products, :product_blockchain_id, :integer

  end
end
