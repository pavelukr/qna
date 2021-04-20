require 'rails_helper'

# ThinkingSphinx::Deltas.resume!

RSpec.configure do |config|
  # Transactional fixtures work with real-time indices
  config.use_transactional_fixtures = false

  config.before :each do |example|
    # Configure and start Sphinx for request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.init
      ThinkingSphinx::Test.start index: false
    end

    # Disable real-time callbacks if Sphinx isn't running
    ThinkingSphinx::Configuration.instance.settings['real_time_callbacks'] =
      (example.metadata[:type] == :request)
  end

  config.after(:each) do |example|
    # Stop Sphinx and clear out data after request specs
    if example.metadata[:type] == :request
      ThinkingSphinx::Test.stop
      ThinkingSphinx::Test.clear
    end
  end

  config.before(:each) do
    # Default to transaction strategy for all specs
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :sphinx => true) do
    # For tests tagged with Sphinx, use deletion (or truncation)
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.append_after(:each) do
    DatabaseCleaner.clean
  end
end
