require 'features_helper.rb'

feature 'User can be authorized via Meetup' do
  background do
    clear_emails
  end
  context 'New user' do
    scenario 'sign up' do
      visit new_user_session_path
      expect(page.body).to have_link('Sign in with Meetup')
      mock_auth_hash
      click_on 'Sign in with Meetup'
      fill_in 'Email', with: 'abc111@mail.ru'
      within('.actions') do
        click_on 'Sign up'
      end
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account. A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')
      visit new_user_session_path
      click_on 'Sign in with Meetup'
      expect(page).to have_content 'You have to confirm your email address before continuing.'
      open_email('abc111@mail.ru')
      current_email.click_link 'Confirm my account'
      visit new_user_session_path
      click_on 'Sign in with Meetup'
      expect(page).to have_content 'Successfully authenticated from Meetup account.'
    end
  end

  context 'existing user' do
    given!(:user) { create(:user)}
    scenario 'sign in' do
      user.authorizations.create(provider: 'meetup', uid: 112233445566)
      visit new_user_session_path
      mock_auth_hash
      click_on 'Sign in with Meetup'
      expect(page).to have_content 'Successfully authenticated from Meetup account.'
    end
  end
end
