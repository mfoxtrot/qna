require 'rails_helper'

feature 'Only authenticated user can add a question', %q{
  User should be authenticated to ask a question
} do
  scenario 'Authenticated user is able to create a question' do
    user = User.create!(email: 'user@test.com', password: '123456')

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: 'Bla'
    fill_in 'Body', with: 'Bla-bla'
    click_on 'Create'

    expect(page).to have_content 'Your question created successfully.'

  end

  scenario 'Non-authenticated user could not create a question' do
    visit questions_path
    click_on 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
