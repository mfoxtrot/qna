class AddBestAnswerToQuestion < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :best_answer, :integer
  end
end
