require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails/capybara"
require 'fakeredis/minitest'
require 'sidekiq/testing'

Sidekiq::Testing.fake!

Dir[Rails.root.join("test/support/**/*")].each { |f| require f }

# Capybara.register_driver :selenium do |app| 
#   profile = Selenium::WebDriver::Firefox::Profile.new 
#   Capybara::Selenium::Driver.new( app, :browser => :firefox, :profile => profile ) 
# end

# Capybara.default_driver = :selenium

Fog.mock!
connection = Fog::Storage.new({
	:provider => 'AWS',
	aws_access_key_id: "secretkeyid",
  aws_secret_access_key: "secretaccesskey"
})
connection.directories.create(:key => CarrierWave::Uploader::Base.fog_directory)

class ActiveSupport::TestCase
	include FactoryGirl::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  Rails.application.config.active_job.queue_adapter = :test
end
