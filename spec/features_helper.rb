require 'rails_helper'
require 'capybara/email/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma

  config.include FeaturesMacros, type: :feature
  config.include WaitForAjax, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include(OmniAuthMacros)

  OmniAuth.config.test_mode = true
end
