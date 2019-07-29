class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes, id: :uuid do |t|
      t.boolean :vote_status
      t.references :review, type: :uuid
      t.references :user, type: :uuid

      t.timestamps
    end
  end
end
