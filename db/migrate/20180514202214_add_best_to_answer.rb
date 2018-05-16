class AddBestToAnswer < ActiveRecord::Migration[5.1]
  def change
    add_column :answers, :best, :boolean

    Answer.find_each do |answer|
      answer.best = answer.best?
      answer.save!
    end
  end
end
