class CreateBlockchains < ActiveRecord::Migration[5.2]
  def change
    create_table :blockchains, id: :uuid do |t|
              t.string :blockchain_hash
	  	t.boolean :mined
	  	t.text :connection
	    t.integer :product_blockchain_id
	    t.integer :rating
	    t.references :product, type: :uuid
	    t.references :user, type: :uuid
      t.timestamps
    end
  end
end
