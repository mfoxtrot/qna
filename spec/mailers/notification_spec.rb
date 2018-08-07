require "rails_helper"

RSpec.describe NotificationMailer, type: :mailer do
  describe "new_answer" do
    let(:answer) { create(:answer) }
    let(:user) { create(:user) }
    let(:mail) { NotificationMailer.new_answer(answer, user) }

    it "renders the headers" do
      expect(mail.subject).to eq("New answer")
      expect(mail.from).to eq(["from@example.com"])
      expect(mail.to).to eq([user.email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
