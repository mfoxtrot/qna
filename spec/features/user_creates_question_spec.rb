require 'rails_helper'

feature 'User creates a question', %q{
  Any User is able to create a question
} do
  scenario 'User try to create a question' do

    User.create!(email: 'user@test.com', password: '12345678')

    visit new_user_session_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    click_on 'Log in'

    visit new_question_path
    fill_in 'Title', with: 'Title of the new question'
    fill_in 'Body', with: 'Lorem ipsum dolor sit amet'
    click_on 'Create a question'

    expect(page).to have_content 'The question was created successfully'

  end
end
