class CreateSubcriptionJoinTable < ActiveRecord::Migration[5.1]
  def change
    create_join_table :users, :questions do |t|
      t.index [:user_id, :question_id], unique: true
    end
  end
end
