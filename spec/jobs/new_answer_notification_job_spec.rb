require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscribers) { create_list(:user, 5) }
  let!(:users) { create_list(:user, 3)}

  it 'sends email to subscribers' do
    answer.question.subscribers.delete(question.author)
    answer.question.subscribers << subscribers

    subscribers.each do |subscriber|
      expect(NotificationMailer).to receive(:new_answer).with(answer, subscriber)
    end
    NewAnswerNotificationJob.perform_now(answer)
  end

  it 'does not send email to all users' do
    users.each do |user|
      expect(NotificationMailer).not_to receive(:new_answer).with(answer, user)
    end
    NewAnswerNotificationJob.perform_now(answer)
  end
end
