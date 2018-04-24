require 'features_helper'

feature 'Authenticated user can answer a question', %q{
  In order to help, authenticated user can answer
  a question
} do

  let(:question) { create(:question) }
  let(:answer) { Faker::Lorem.unique.sentence }

  scenario 'Authenticated user can answer a question', js: true do
    sign_in_user
    visit question_path(question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    within '.answers' do
      expect(page).to have_content answer
    end
  end

  scenario 'Non-authenticated user can not answer a question' do
    visit question_path(question)
    fill_in 'answer[body]', with: answer
    click_on 'Post an answer'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  scenario 'Authenticated user recieves an error using invalid params', js: true do
    sign_in_user
    visit question_path(question)
    click_on 'Post an answer'

    expect(page).to have_content "Body can't be blank"
  end
end
