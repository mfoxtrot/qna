require 'features_helper'

feature 'Only authenticated user can add a question', %q{
  User should be authenticated to ask a question
} do

  let(:user) { create(:user) }

  scenario 'Authenticated user is able to create a question' do
    sign_in_user(user)

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
    expect(page).not_to have_link 'Ask a question'
  end

  scenario 'Authenticated user recieves an error using invalid params' do
    sign_in_user(user)

    title = Faker::Lorem.unique.sentence
    body = nil

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    click_on 'Create'

    expect(page).to have_content "Body can't be blank"
  end

  context 'multiple sessions' do
    scenario "questions appears on another user's page", js: true do
      title = Faker::Lorem.unique.sentence
      body = Faker::Lorem.unique.sentence

      Capybara.using_session('user') do
        sign_in_user(user)
        visit questions_path
      end

      Capybara.using_session('guest') do
        visit questions_path
      end

      Capybara.using_session('user') do
        click_on 'Ask a question'
        fill_in 'Title', with: title
        fill_in 'Body', with: body
        click_on 'Create'
        expect(page).to have_content 'The question was created successfully'
        expect(page).to have_content title
        expect(page).to have_content body
      end

      Capybara.using_session('guest') do
        expect(page).to have_content body
      end
    end
  end
end
