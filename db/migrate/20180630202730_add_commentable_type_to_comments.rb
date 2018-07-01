class AddCommentableTypeToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :commentable_type, :string

    add_index :comments, [:commentable_id, :commentable_type]
  end
end
