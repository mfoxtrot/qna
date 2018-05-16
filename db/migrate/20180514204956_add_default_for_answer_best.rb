class AddDefaultForAnswerBest < ActiveRecord::Migration[5.1]
  def change
    change_column :answers, :best, :boolean, default: false

    Answer.find_each do |answer|
      if answer.best.nil?
        answer.best = false
        answer.save!
      end
    end
  end
end
