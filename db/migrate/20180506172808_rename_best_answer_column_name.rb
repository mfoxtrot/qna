class RenameBestAnswerColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :questions, :best_answer, :best_answer_id
  end
end
