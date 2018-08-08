require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do

  describe 'CREATE #new' do
    let!(:question) { create(:question) }
    let!(:user) { create(:user)}
    let(:action) { post :create, params: {question_id: question.id}, format: :json }

    context 'Non-authenticated user' do
      it 'is not able to create new subscription' do
        expect {action}.not_to change(Subscription.all, :count)
      end
    end

    context 'Authenticated user' do
      it 'creates new subscription' do
        sign_in(user)
        expect {action}.to change(Subscription.all, :count).by(1)
      end

      it 'destroys existed subscription' do
        subscription = Subscription.create(user: user, question: question)
        sign_in(user)
        expect {delete :destroy, params: {id: subscription.id}, format: :json }.to change(Subscription, :count).by(-1)
      end
    end
  end
end
