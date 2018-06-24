class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.integer :votable_id
      t.string :votable_type
      t.integer :value
      t.references :user

      t.timestamps
    end

    add_index :votes, [:votable_id, :votable_type]
    add_index :votes, [:user_id, :votable_id], unique: true
  end
end
