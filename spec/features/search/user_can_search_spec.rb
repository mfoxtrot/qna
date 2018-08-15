require 'features_helper'
#require 'sphinx_helper'

feature 'user is able to search' do
  describe 'Any user can type a string in a search form and get the result' do

    it 'if type result string and click find' do
      visit root_path
      fill_in 'search_field', with: 'question'
      click_on('find')

      within('.search_results .result') do
        expect(page).to have_content('found')
      end
    end

    context 'search results include question' do
      let!(:question) {create(:question, title: 'How much is the fish?')}
      let!(:another_question) { create(:question)}
      it 'returns found question' do
        index
        visit root_path
        fill_in 'search_field', with: 'fish'
        click_on('find')

        within('.search_results .result') do
          expect(page).to have_content('1 item found')
        end

        within('.search_results .items') do
          expect(page).to have_content(question.title)
        end
      end
    end

    context 'search results include answers' do
      let!(:answer) { create(:answer, body: 'Test body')}
      let!(:another_answer) { create(:answer)}
      it 'returns found answer' do
        index
        visit root_path
        fill_in 'search_field', with: 'body'
        click_on('find')
        within('.search_results .result') do
          expect(page).to have_content('1 item found')
        end

        within('.search_results .items') do
          expect(page).to have_content(answer.body)
        end
      end
    end
  #
    context 'search results include comments' do
      let!(:question) { create(:question)}
      let!(:comment) { create(:question_comment, commentable: question, body: 'This is a new comment')}
      it 'returns found comment' do
        index
        visit root_path
        fill_in 'search_field', with: 'new'
        click_on('find')

        within('.search_results .result') do
          expect(page).to have_content('1 item found')
        end

        within('.search_results .items') do
          expect(page).to have_content(comment.body)
        end
      end
    end
  end
end
