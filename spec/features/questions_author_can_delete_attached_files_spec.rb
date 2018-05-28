require 'features_helper'

feature 'Question''s author can delete attached files' do

  given!(:question) { create(:question) }
  given!(:user) { create(:user) }

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
      sign_in_user(user)

      title = Faker::Lorem.unique.sentence
      body = Faker::Lorem.unique.sentence

      click_on 'Ask a question'
      fill_in 'Title', with: title
      fill_in 'Body', with: body
      attach_file 'File', "#{Rails.root}/spec/fixtures/files/file_upload_test.txt"
      click_on 'Create'

      wait_for_ajax

      created_question = Question.last
      visit question_path(created_question)
      within('.attachments') do
        click_on 'Delete file'
      end
      expect(page).not_to have_link 'file_upload_test.txt'
    end
  end
end
