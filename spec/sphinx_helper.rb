RSpec.configure do |config|

  config.before :each do |example|
    if example.metadata[:type] == :requiest
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    ThinkingSphinx::Configuration.instance_settings['real_time_callbacks'] = (example.metadata[:type] == :request)
  end

  config.after :each do |example|
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end
end
