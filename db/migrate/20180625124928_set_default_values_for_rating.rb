class SetDefaultValuesForRating < ActiveRecord::Migration[5.1]
  def change
    change_column :questions, :rating, :integer, default: 0
    change_column :answers, :rating, :integer, default: 0
  end
end
