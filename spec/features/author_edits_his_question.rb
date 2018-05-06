require 'features_helper.rb'

feature 'Author edits his question', %q{
  In order to fix errors, author is able
  to edit his questions
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  describe 'Authenticated user' do
    before { sign_in_user(user) }

    describe 'if he is an author of the question' do
      scenario 'view Edit link on questions page'
      scenario 'edit body of his question'
    end

    describe 'if he is not an author of the question' do
      scenario 'does not see Edit link on questions page' do
        visit questions_path
        expect(page).not_to have_link 'Edit'
      end
    end
  end

  describe 'Non-authenticated user' do
    scenario 'does not see Edit link on questions page' do
      visit questions_path
      expect(page).not_to have_link 'Edit'
    end
  end

end
