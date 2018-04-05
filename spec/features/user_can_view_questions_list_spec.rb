require 'rails_helper'

feature 'User is able to view questions list', %q{
  Any user is able to view question list
} do
  scenario 'User try to view questions list' do
    visit questions_path
    expect(page).to have_content 'Questions list'
  end
end
