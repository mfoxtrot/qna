require 'features_helper'

feature 'User is able to sign in', %q{
  In order to ask a question
  User is able to sign in
} do

  let(:user) { create(:user) }

  scenario 'Registered user try to sign in' do
    sign_in_user(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(current_path).to eq root_path
  end

  scenario 'Unregisterd user try to sign in' do
    visit new_user_session_path
    fill_in 'Email', with: 'wronguser@test.com'
    fill_in 'Password', with: 'wrong_password'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
    expect(current_path).to eq new_user_session_path
  end
end
