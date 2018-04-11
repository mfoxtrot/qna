require 'rails_helper'

feature 'User can delete his question or answer' do
  background do
    sign_in_user
    @user1 = create(:user)
  end

  scenario 'User can delete his question' do
    question = create(:question, author: @user)

    visit question_path(question)
    click_on 'Delete question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(current_path).to eq questions_path
  end

  scenario 'User can not delete another''s question' do
    question = create(:question, author: @user1)

    visit question_path(question)

    expect(page).to have_no_content 'Delete question'
  end

  scenario 'User can delete his answer' do
    question = create(:question, author: @user1)
    answer = create(:answer, question: question, author: @user)

    visit question_path(question)

    find_link('Delete', href: answer_path(answer)).click

    expect(page).to have_content 'Answer was successfully deleted'
    expect(current_path).to eq question_path(question)
  end

  scenario 'User can not delete another''s answer' do
    question = create(:question, author: @user1)
    answer = create(:answer, question: question, author: @user1)

    visit question_path(question)

    expect(page).to have_no_link('Delete', answer_path(answer))
  end
end
