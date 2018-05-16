class RemoveBestAnswerId < ActiveRecord::Migration[5.1]
  def change
    remove_column :questions, :best_answer_id
  end
end
