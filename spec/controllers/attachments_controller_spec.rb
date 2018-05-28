require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:question) { create(:question) }
  let!(:attachment) { create(:attachment, attachable: question) }

  describe 'DELETE #destroy' do
    let(:delete_action) { delete :destroy, params: {id: attachment}, format: :js }

    context 'if attachments.parent belongs to the user' do

      it 'deletes attachment' do
        attachment
        sign_in(question.author)
        expect { delete_action }.to change(Attachment, :count).by(-1)
      end
    end

    context 'if answer does not belong to the user' do
      let!(:user) { create(:user) }

      it 'does not delete attachment' do
        attachment
        sign_in(user)
        expect { delete_action }.to_not change(Attachment, :count)
      end
    end

  end


end
