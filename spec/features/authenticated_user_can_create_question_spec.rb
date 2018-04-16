require 'rails_helper'

feature 'Only authenticated user can add a question', %q{
  User should be authenticated to ask a question
} do
  scenario 'Authenticated user is able to create a question' do
    sign_in_user

    title = Faker::Lorem.unique.sentence
    body = Faker::Lorem.unique.sentence

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    click_on 'Create'

    expect(page).to have_content 'The question was created successfully'
    expect(page).to have_content title
    expect(page).to have_content body
  end

  scenario 'Non-authenticated user could not create a question' do
    visit questions_path
    click_on 'Ask a question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user recieves an error using invalid params' do
    sign_in_user

    title = Faker::Lorem.unique.sentence
    body = nil

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end
end
