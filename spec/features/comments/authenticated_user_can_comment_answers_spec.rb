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

  context 'Multiple sessions' do
    given!(:another_question) { create(:question) }
    scenario 'user can vew new added comments while viewing answers on a question page', js: true do
      Capybara.using_session('user') do
        sign_in_user(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('guest_viewing_another_question') do
        visit question_path(another_question)
      end

      Capybara.using_session('user') do
        within(".answer_comments[data-id='#{answer.id}']") do
          fill_in 'answer[comment_body]', with: comment_body
          click_on 'Comment'

          within('.comments_list') do
            expect(page).to have_content(comment_body)
          end
        end
      end

      Capybara.using_session('guest') do
        within(".answer_comments[data-id='#{answer.id}'] .comments_list") do
          expect(page).to have_content(comment_body)
        end
      end

      Capybara.using_session('guest_viewing_another_question') do
        expect(page).not_to have_content(comment_body)
      end
    end
  end
end
