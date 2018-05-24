require 'features_helper.rb'

feature 'User can add files to questions', %w{
  In order to illustrate a question, user can
  add files to his question
} do

  given!(:user) { create(:user) }

  background do
    sign_in_user(user)
    visit questions_path
  end

  scenario 'User adds a file while asking a question', js: true do
    title = Faker::Lorem.unique.sentence
    body = Faker::Lorem.unique.sentence

    click_on 'Ask a question'
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    attach_file 'File', "#{Rails.root}/spec/fixtures/files/file_upload_test.txt"
    click_on 'Create'

    expect(page).to have_link 'file_upload_test.txt', href: '/uploads/attachment/file/1/file_upload_test.txt'
  end

  scenario 'User adds multiple files while asking a question', js: true do
    title = Faker::Lorem.unique.sentence
    body = Faker::Lorem.unique.sentence

    click_on 'Ask a question'
    fill_in 'Title', with: title
    fill_in 'Body', with: body
    attach_file 'File', "#{Rails.root}/spec/fixtures/files/file_upload_test.txt"
    click_on 'add file'
    page.all(:css, 'input[type="file"]')[1].set("#{Rails.root}/spec/fixtures/files/file_upload_test2.txt")

    click_on 'Create'

    expect(page).to have_link 'file_upload_test.txt', href: '/uploads/attachment/file/1/file_upload_test.txt'
    expect(page).to have_link 'file_upload_test2.txt', href: '/uploads/attachment/file/2/file_upload_test2.txt'
  end

end
