class NewAnswerNotificationJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    answer.question.subscribers.each do |user|
      NotificationMailer.new_answer(answer, user)
    end
  end
end
