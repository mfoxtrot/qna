require 'features_helper'

feature 'User can delete his answer' do
  background do
    sign_in_user(user)
  end
  let(:user) { create(:user)}
  let(:user1) { create(:user) }
  let(:question) { create(:question, author: user1) }

  scenario 'User can delete his answer' do
    answer = create(:answer, question: question, author: user)

    visit question_path(question)

    expect(page).to have_content answer.body

    find_link('Delete', href: answer_path(answer)).click

    expect(page).to have_content 'Answer was successfully deleted'
    expect(current_path).to eq question_path(question)
    expect(page).to have_no_content answer.body
  end

  scenario 'User can not delete another''s answer' do
    answer = create(:answer, question: question, author: user1)

    visit question_path(question)

    expect(page).to have_no_link('Delete', answer_path(answer))
  end
end
