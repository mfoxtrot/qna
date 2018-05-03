require 'features_helper'

feature 'Logged in user can sign out', %q{
  In order to finish work
  logged in user can sign out
} do

  let(:user) { create(:user) }

  scenario 'Logged in user can sign out' do
    sign_in_user(user)

    click_on 'Log out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'Signed out successfully.'

  end
end
