require 'features_helper.rb'

feature 'Author edits his question', %q{
  In order to fix errors, author is able
  to edit his questions
} do

  describe 'Author can' do
    scenario 'view Edit link on questions page'
    scenario 'edit body of his question'
  end

  describe 'Non-author' do
    scenario 'does not see Edit link on questions page'
  end

  describe 'Non-authenticated user' do
    scenario 'does not see Edit link on questions page'
  end

end
