require 'features_helper'

feature 'Answer''s author can delete attached files' do

  given!(:answer) { create(:answer) }
  given!(:attachment) { create(:attachment, attachable: answer) }
  given!(:user) { create(:user) }

  context 'Non-authenticated user' do
    scenario 'Is not able to delete attached files' do
      visit question_path(answer.question)
      within('.answers') do
        expect(page).not_to have_link 'Delete file'
      end
    end
  end

  context 'Authenticated user' do
    scenario 'Is not able to delete another''s answer''s files' do
      sign_in_user(user)
      visit question_path(answer.question)
      within('.answers') do
        expect(page).not_to have_link 'Delete file'
      end
    end

    scenario 'Is able to delete his answer''s files', js: true do
      sign_in_user(answer.author)

      visit question_path(answer.question)

      within('.answers') do
        click_on 'Delete file'
      expect(page).not_to have_link 'Delete file'        
      end

    end
  end
end
