require 'features_helper.rb'

feature 'Author can choose the best answer' do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user) { create(:user) }
  given!(:big_question) { create(:question_with_answers) }

  describe 'Non authenticated user' do
    scenario 'cant choose the best answer for the question' do
      visit question_path(question)
      expect(page).not_to have_link 'Mark as the best'
    end
  end

  describe 'Authenticated user' do
    describe 'if he is not the author of the question' do
      scenario 'can not choose the best answer' do
        sign_in_user(user)
        visit question_path(question)
        expect(page).not_to have_link 'Mark as the best'
      end
    end

    describe 'if he is the author of the question' do
      scenario 'can choose the best answer', js: true do
        author = question.author
        sign_in_user(author)
        visit question_path(question)
        click_on 'Mark as the best'

        expect(page).to have_content 'The best answer'
      end

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

      scenario 'the best answer should be the first in the list', js: true do
        sign_in_user(big_question.author)
        visit question_path(big_question)

        best_answer = big_question.answers[5]

        within("#answer-#{best_answer.id}") do
          click_on 'Mark as the best'
        end
        expect(page).to have_content 'The best answer'
        expect(first('.answers li').text).to have_content 'The best answer'
      end
    end
  end
end
