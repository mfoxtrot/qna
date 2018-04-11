require 'rails_helper'

feature 'User can add an answer from the questions page directly', %q{
  In order to help with the question user is able to write an answer
  from the questions page directly
} do
  scenario 'User can add an answer' do
    sign_in_user
    question = create(:question)

    visit question_path(question)
    fill_in 'answer[body]', with: Faker::Lorem.unique.sentence
    click_on 'Post an answer'

    expect(page).to have_content 'New answer was added'
  end
end
