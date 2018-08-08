require 'rails_helper'

RSpec.describe NewAnswerNotificationJob, type: :job do
  let!(:question) { create(:question) }
  let!(:answer) { create(:answer, question: question) }
  let!(:subscribers) { create_list(:user, 5) }
  let(:subscribe_action) {
    answer.question.subscribers.delete(question.author)
    answer.question.subscribers << subscribers
  }

  it 'sends email to subscribers' do
    subscribe_action

    subscribers.each do |subscriber|
      message_delivery = instance_double(ActionMailer::MessageDelivery)
      expect(NotificationMailer).to receive(:new_answer).with(answer, subscriber).and_return(message_delivery)
      allow(message_delivery).to receive(:deliver_later)
    end
    NewAnswerNotificationJob.perform_now(answer)
  end
end
