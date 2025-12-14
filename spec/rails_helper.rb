require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods
  config.use_transactional_fixtures = true
  config.order = :random
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  config.include Warden::Test::Helpers, type: :system
  config.before(:suite) { Warden.test_mode! }
  config.after(:each) { Warden.test_reset! }

  config.include Devise::Test::IntegrationHelpers, type: :request

  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end
end
