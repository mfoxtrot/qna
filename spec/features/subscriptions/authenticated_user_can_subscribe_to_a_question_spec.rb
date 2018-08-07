require 'features_helper'

feature 'Authenticated user can subscribe to a question' do
  given!(:question) { create(:question)}
  given!(:user) { create(:user)}

  context 'Non-authenticated user' do
    scenario 'is not able to subscribe to a question' do
      visit question_path(question)
      within(".subscriptions") do
        expect(page).not_to have_link 'Subscribe'
        expect(page).not_to have_link 'Unsubscribe'
      end
    end
  end

  context 'Authenticated user' do
    scenario 'is able to subscribe to a question', js: true do
      sign_in_user(user)
      visit question_path(question)
      within(".subscriptions") do
        click_on 'Subscribe'
        expect(page).to have_content 'You have successfully subscribed to the question'
        expect(page).not_to have_link 'Subscribe'
        expect(page).to have_link 'Unsubscribe'
      end

    end

    scenario 'is able to unsubscribe from a question', js: true do
      sign_in_user(user)
      user.subscriptions << question
      visit question_path(question)
      within(".subscriptions") do
        click_on 'Unsubscribe'
        expect(page).to have_content 'You have successfully unsubscribed from the question'
        expect(page).not_to have_link 'Unsubscribe'
        expect(page).to have_link 'Subscribe'
      end
    end
  end
end
