require 'rails_helper'

feature 'User can add an answer from the questions page directly', %q{
  In order to help with the question user is able to write an answer
  from the questions page directly
} do
  scenario 'User can add an answer' do
    user = create(:user)#User.create!(email: 'user@test.com', password: '123456')
    question = create(:question)#Question.create(title: 'New question', body: 'Lorem ipsum dolor sit amet')

    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'

    visit question_path(question)
    fill_in 'answer[body]', with: Faker::Lorem.unique.sentence
    click_on 'Post an answer'

    expect(page).to have_content 'New answer was added'

  end
end
