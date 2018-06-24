require 'features_helper.rb'

feature 'Authenticated user can vote for a question he likes' do

  given!(:question) { create(:question)}
  given!(:user) { create(:user)}

  context 'Non-authenticated user' do
    scenario 'is not able to vote up or down a question' do
      visit question_path(question)
      within('.question') do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end

  context 'Author' do
    scenario 'is not able to vote up or down a question' do
      sign_in_user(question.author)
      visit question_path(question)
      within('.question') do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end

  context 'Non-author' do
    scenario 'is able to vote up a question', js: true do
      sign_in_user(user)
      visit question_path(question)
      within('.question_vote') do
        click_on 'Vote up'
      end
      expect(page).to have_content 'You have successfully voted for the question'
    end

    scenario 'is able to vote down a question', js: true do
      sign_in_user(user)
      visit question_path(question)
      within('.question_vote') do
        click_on 'Vote down'
      end
      expect(page).to have_content 'You have successfully voted for the question'
    end

    scenario 'is not able to vote for a question twice', js: true do
      sign_in_user(user)
      visit question_path(question)
      within('.question_vote') do
        click_on 'Vote up'
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end

    scenario 'is able to revote a question', js: true do
      sign_in_user(user)
      visit question_path(question)
      within('.question_vote') do
        click_on 'Vote up'
        click_on 'Delete vote'
        click_on 'Vote down'
      end
      expect(page).to have_content 'You have successfully voted for the question'
    end
  end
end
