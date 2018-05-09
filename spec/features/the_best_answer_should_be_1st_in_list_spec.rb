require 'features_helper.rb'

feature 'The best answer' do
  given!(:question) { create(:question_with_answers) }

  scenario 'should be the first in the list', js: true do
    sign_in_user(question.author)
    visit question_path(question)

    best_answer = question.answers[5]

    within("#answer-#{best_answer.id}") do
      click_on 'Mark as the best'
    end
    expect(page).to have_content 'The best answer'
    expect(first('.answers li').text).to have_content 'The best answer'
  end
end
