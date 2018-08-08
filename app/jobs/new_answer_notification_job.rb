class NewAnswerNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.find_each do |user|
      NotificationMailer.new_answer(answer, user).deliver_later
    end
  end
end
