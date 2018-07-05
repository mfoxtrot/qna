require 'features_helper.rb'

feature 'User can be authorized via Github' do
  context 'User authorized by the provider' do
    it 'can sign in' do
      visit new_user_session_path
      expect(page.body).to have_link('Sign in with GitHub')
      mock_auth_hash
      click_on 'Sign in with GitHub'
      expect(page).to have_content('Successfully authenticated from Github account')

    end
  end
end
