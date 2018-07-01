class AddCommentsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :comments do |t|
      t.integer :commentable_id
      t.text :body
      t.references :user

      t.timestamps
    end

    add_index :comments, [:commentable_id]
  end
end
