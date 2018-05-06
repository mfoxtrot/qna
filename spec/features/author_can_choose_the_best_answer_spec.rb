require 'features_helper.rb'

feature 'Author can choose the best answer' do

  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }
  given!(:user) { create(:user) }

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
      scenario 'can choose the best answer' do
        author = question.author
        sign_in_user(author)
        visit question_path(question)
        click_on 'Mark as the best'

        expect(page).to have_content 'The best answer'
      end
    end
  end
end
