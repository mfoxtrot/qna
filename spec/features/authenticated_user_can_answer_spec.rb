require 'rails_helper'

feature 'Authenticated user can answer a question', %q{
  In order to help, authenticated user can answer
  a question
} do

  background do
    @question = create(:question)
  end

  scenario 'Authenticated user can answer a question' do
    sign_in_user

    answer = create(:answer)

    visit question_path(@question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    expect(page).to have_content 'New answer was added'
    expect(page).to have_content answer
  end

  scenario 'Non-authenticated user can not answer a question' do
    answer = Faker::Lorem.unique.sentence

    visit question_path(@question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
