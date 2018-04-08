require 'rails_helper'

feature 'User can add an answer from the questions page directly', %q{
  In order to help with the question user is able to write an answer
  from the questions page directly
} do
  scenario 'User can add an answer' do
    question = Question.create(title: 'New question', body: 'Lorem ipsum dolor sit amet')

    visit question_path(question)
    fill_in 'answer[body]', with: 'This is a new answer'
    click_on 'Post an answer'

    expect(page).to have_content 'New answer was added'

  end
end
