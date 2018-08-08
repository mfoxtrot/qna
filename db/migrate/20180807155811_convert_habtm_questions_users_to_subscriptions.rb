class ConvertHabtmQuestionsUsersToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    rename_table 'questions_users', 'subscriptions'
    add_column :subscriptions, :id, :primary_key
  end
end
