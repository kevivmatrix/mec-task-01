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
def test_enumerized factory_symbol, field, class_constant, desired_array, same_order_required = false, multiple = false
	if same_order_required
		class_constant = class_constant.sort
		desired_array = desired_array.sort
	end
	valid_checks = Array.new
	valid_checks << ( class_constant == desired_array )
	factory = FactoryGirl.build(factory_symbol)
	valid_checks << if multiple
		factory.send(field) << desired_array.sample
		factory[field].class.to_s == "Array"
	else
		factory.send("#{field}=", desired_array.sample)
		factory[field].class.to_s == "String"
	end
	valid_checks << factory.valid?
	valid_checks << FactoryGirl.build(factory_symbol, field => Faker::Lorem.word).invalid?
	valid_checks.inject(:&)
end
