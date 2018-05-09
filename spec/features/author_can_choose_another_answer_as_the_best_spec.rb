require 'features_helper.rb'

feature 'Author can choose another answer as the best one' do

  context 'Author' do
    scenario 'can chose another answer as the best one', js: true do

      question = create(:question)
      answer = create(:answer, body: 'answer1', question: question)
      another_answer = create(:answer, body: 'answer2', question: question)

      sign_in_user(question.author)
      visit question_path(question)

      within("#answer-#{answer.id}") do
        click_on 'Mark as the best'
      end
      # Answer is the best answer?
      expect(page).to have_css "#answer-#{answer.id}", text: 'The best answer'

      within("#answer-#{another_answer.id}") do
        click_on 'Mark as the best'
      end
      # Another answer is the best one?
      expect(page).not_to have_css "#answer-#{answer.id}", text: 'The best answer'
      expect(page).to have_css "#answer-#{another_answer.id}", text: 'The best answer'
    end
  end

end
