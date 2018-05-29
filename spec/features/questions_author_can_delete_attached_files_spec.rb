require 'features_helper'

feature 'Question''s author can delete attached files' do

  given!(:question) { create(:question) }
  given!(:user) { create(:user) }
  given!(:attachment) { create(:attachment, attachable: question)}

  context 'Non-authenticated user' do
    scenario 'Is not able to delete attached files' do
      visit question_path(question)
      within('.attachments') do
        expect(page).not_to have_link 'Delete file'
      end
    end
  end

  context 'Authenticated user' do
    scenario 'Is not able to delete another''s question''s files' do
      sign_in_user(user)
      visit question_path(question)
      within('.attachments') do
        expect(page).not_to have_link 'Delete file'
      end
    end

    scenario 'Is able to delete his question''s files', js: true do
      sign_in_user(question.author)

      visit question_path(question)
      within('.attachments') do
        click_on 'Delete file'
        expect(page).not_to have_link 'Delete file'
      end
    end
  end
end
