require 'features_helper.rb'

feature 'Authenticated user can vote for an answer he likes' do

  given!(:answer) { create(:answer)}
  given!(:user) { create(:user)}

  context 'Non-authenticated user' do
    scenario 'is not able to vote up or down an answer' do
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end

  context 'Author' do
    scenario 'is not able to vote up or down an answer' do
      sign_in_user(answer.author)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end
  end

  context 'Non-author' do
    scenario 'is able to vote up an answer', js: true do
      sign_in_user(user)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        click_on 'Vote up'
        expect(page).to have_content 'You have successfully voted for the answer'
      end

    end

    scenario 'is able to vote down an answer', js: true do
      sign_in_user(user)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        click_on 'Vote down'
      end
      expect(page).to have_content 'You have successfully voted for the answer'
    end

    scenario 'is not able to vote for an answer twice', js: true do
      sign_in_user(user)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        click_on 'Vote up'
        expect(page).not_to have_link 'Vote up'
        expect(page).not_to have_link 'Vote down'
      end
    end

    scenario 'is able to revote an answer', js: true do
      sign_in_user(user)
      visit question_path(answer.question)
      within("#answer-#{answer.id}") do
        click_on 'Vote up'
        click_on 'Delete vote'
        click_on 'Vote down'
        expect(page).to have_content 'You have successfully voted for the answer'
      end
    end
  end
end
