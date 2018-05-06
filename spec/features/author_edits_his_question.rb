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

      scenario 'view Edit link on questions page' do
        expect(page).to have_link 'Edit'
      end
      scenario 'edit body of his question'
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
