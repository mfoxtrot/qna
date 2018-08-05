require 'rails_helper'

RSpec.describe DailyDigestJob, type: :job do
  let(:users_list) { create_list(:user, 5)}

  it 'sends daily digest' do
    users_list.each do |user|
      expect(DailyMailer).to receive(:digest).with(user)
    end
    DailyDigestJob.perform_now
  end
end
