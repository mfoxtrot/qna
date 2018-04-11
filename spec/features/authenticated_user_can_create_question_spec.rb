require 'rails_helper'

feature 'Only authenticated user can add a question', %q{
  User should be authenticated to ask a question
} do
  scenario 'Authenticated user is able to create a question' do
    sign_in_user

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: Faker::Lorem.unique.sentence
    fill_in 'Body', with: Faker::Lorem.unique.paragraph
    click_on 'Create'

    expect(page).to have_content 'The question was created successfully'

  end

  scenario 'Non-authenticated user could not create a question' do
    visit questions_path
    click_on 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
