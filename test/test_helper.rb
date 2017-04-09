require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/rails/capybara"

class ActiveSupport::TestCase
	include FactoryGirl::Syntax::Methods
	# include CommonHelper
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

# TODO - Move to a better place
def test_enumerized factory_symbol, field, class_constant, desired_array, same_order_required = false
	if same_order_required
		class_constant = class_constant.sort
		desired_array = desired_array.sort
	end
	valid_checks = Array.new
	valid_checks << ( class_constant == desired_array )
	valid_checks += desired_array.map do |element|
		factory = FactoryGirl.build(factory_symbol)
		case factory.send(field).class.to_s
		when "Enumerize::Set"
			factory.send(field) << element
		when "Enumerize::Value"
			factory.send("#{field}=", element)
		end
		factory.valid?
	end
	valid_checks << FactoryGirl.build(factory_symbol, field => Faker::Lorem.word).invalid?
	valid_checks.inject(:&)
end
