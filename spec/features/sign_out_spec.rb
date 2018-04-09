require 'rails_helper'

feature 'Logged in user can sign out', %w{
  In order to finish work
  logged in user can sign out
} do

  scenario 'Logged in user can sign out' do
    user = create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    click_on 'Log out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'

  end
end
