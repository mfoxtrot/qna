class AddRatingToQuestionsAndAnswers < ActiveRecord::Migration[5.1]
  def change
    add_column :questions, :rating, :integer
    add_column :answers, :rating, :integer
  end
end
