require 'features_helper.rb'

feature 'Author edits his question', %q{
  In order to fix errors, author is able
  to edit his questions
} do

  describe 'Authenticated user' do
    given!(:user) { create(:user) }
    before { sign_in_user(user) }

    describe 'if he is an author of the question' do
      given!(:users_question) { create(:question, author: user)}
      before { visit questions_path }

      scenario 'sees Edit link on questions page' do
        expect(page).to have_link 'Edit'
      end
      scenario 'edits his question', js: true do
        click_on 'Edit'
        fill_in 'question[title]', with: 'New title'
        fill_in 'question[body]', with: 'New body'
        click_on 'Save'
        expect(page).to have_content 'New title'
        expect(page).to have_content 'New body'
        expect(page).not_to have_content users_question.title
        expect(page).not_to have_content users_question.body
        expect(page).not_to have_selector 'form'
      end
    end

    describe 'if he is not an author of the question' do
      given!(:question) { create(:question) }
      before { visit questions_path }

      scenario 'does not see Edit link on questions page' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end

  describe 'Non-authenticated user' do
    given!(:question) { create(:question) }
    scenario 'does not see Edit link on questions page' do
      visit questions_path
      expect(page).not_to have_link 'Edit'
    end
  end

end
