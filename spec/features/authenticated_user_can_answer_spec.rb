require 'rails_helper'

feature 'Authenticated user can answer a question', %q{
  In order to help, authenticated user can answer
  a question
} do

  scenario 'Authenticated user can answer a question' do
    user = User.create!(email: 'user@test.com', password: '123456')
    question = Question.create!(title: 'Some title', body: 'Question body')
    answer = Faker::Lorem.unique.sentence

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit question_path(question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    expect(page).to have_content 'New answer was added'
    expect(page).to have_content answer
  end

  scenario 'Non-authenticated user can not answer a question' do
    question = Question.create!(title: 'Some title', body: 'Question body')
    answer = Faker::Lorem.unique.sentence

    visit question_path(question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
