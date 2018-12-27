require 'features_helper'

feature 'User can sign up', %q{
  In order to user the service
  User can sign up
} do
  scenario 'User sign up' do
    clear_emails
    email = Faker::Internet.unique.email
    visit new_user_registration_path
    fill_in 'user_email', with: email
    password = Faker::Internet.unique.password
    fill_in 'user_password', with: password
    fill_in 'user_password_confirmation', with: password
    within('.actions') do
      click_on 'Sign up'
    end
    open_email(email)
    current_email.click_link 'Confirm my account'

    visit user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    within('.actions') do
      click_on 'Log in'
    end
    expect(page).to have_content 'Signed in successfully'

  end
end
