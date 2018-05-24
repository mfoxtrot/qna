require 'features_helper.rb'

feature 'User can add files to answers' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { Faker::Lorem.unique.sentence }

  background do
    sign_in_user(user)
    visit question_path(question)
  end

  scenario 'User adds file when asking question', js: true do
    fill_in 'answer[body]', with: answer
    attach_file 'File', "#{Rails.root}/spec/fixtures/files/file_upload_test.txt"
    click_on 'Post an answer'

    within '.answers' do
      expect(page).to have_link 'file_upload_test.txt', href: '/uploads/attachment/file/1/file_upload_test.txt'
    end
  end

  scenario 'User adds multiple files while answering the question', js: true do
    fill_in 'answer[body]', with: answer
    attach_file 'File', "#{Rails.root}/spec/fixtures/files/file_upload_test.txt"
    click_on 'add file'
    page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/fixtures/files/file_upload_test2.txt")

    click_on 'Post an answer'

    within '.answers' do
      expect(page).to have_link 'file_upload_test.txt', href: '/uploads/attachment/file/1/file_upload_test.txt'
      expect(page).to have_link 'file_upload_test2.txt', href: '/uploads/attachment/file/2/file_upload_test2.txt'
    end
  end
end
