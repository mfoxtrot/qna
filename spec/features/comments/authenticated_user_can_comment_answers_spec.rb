require 'features_helper.rb'

feature 'Authenticated user is able to comment an answer' do

  given!(:question) { create(:question)}
  given!(:answer) { create(:answer, question: question)}
  given!(:user) { create(:user)}
  given!(:comment_body) { Faker::Lorem.unique.sentence }

  context 'Non-authenticated user' do
    scenario 'is not able to comment a question' do
      visit question_path(question)
      within(".answer_comments[data-id='#{answer.id}']") do
        expect(page).not_to have_link 'Comment'
      end
    end
  end

  context 'Authenticated user' do
    scenario 'is able to comment an answer', js: true do

      sign_in_user(user)
      visit question_path(question)
      within(".answer_comments[data-id='#{answer.id}']") do
        fill_in 'answer[comment_body]', with: comment_body
        click_on 'Comment'

        within('.comments_list') do
          expect(page).to have_content(comment_body)
        end
      end
    end
  end
end
