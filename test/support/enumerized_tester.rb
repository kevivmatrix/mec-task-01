require 'active_support/test_case'
require 'ostruct'

class ActiveSupport::TestCase

	def valid_enumerized factory_symbol, field, class_constant, desired_array, multiple = false, same_order_required = false
		@valid_enumerized_errors = Array.new
		@valid_enumerized_checks = Array.new
		if same_order_required
			class_constant = class_constant.sort
			desired_array = desired_array.sort
		end
		match_valid_enumerized_desired_array(class_constant, desired_array)
		factory = FactoryGirl.build(factory_symbol)
		if multiple
			factory.send(field) << desired_array.sample
			check_valid_enumerized_field_as_array(factory, field)
		else
			factory.send("#{field}=", desired_array.sample)
			check_valid_enumerized_field_as_string(factory, field)
		end
		valid_enumerized_check_for_correct_value(factory)
		invalid_factory = FactoryGirl.build(factory_symbol, field => Faker::Lorem.word)
		valid_enumerized_check_for_incorrect_value(invalid_factory)
		OpenStruct.new({
			valid: @valid_enumerized_checks.inject(:&), 
			messages: @valid_enumerized_errors
		})
	end

	private

		def match_valid_enumerized_desired_array class_constant, desired_array
			@valid_enumerized_checks << valid_check = class_constant == desired_array
			@valid_enumerized_errors << "Mismatch in enumerize desired array" unless valid_check
		end

		def check_valid_enumerized_field_as_array factory, field
			@valid_enumerized_checks << valid_check = factory[field].class.to_s == "Array"
			@valid_enumerized_errors << "Enumerized field is not an Array" unless valid_check
		end

		def check_valid_enumerized_field_as_string factory, field
			@valid_enumerized_checks << valid_check = factory[field].class.to_s == "String"
			@valid_enumerized_errors << "Enumerized field is not a String" unless valid_check
		end

		def valid_enumerized_check_for_correct_value factory
			@valid_enumerized_checks << valid_check = factory.valid?
			@valid_enumerized_errors << "Enumerized field returns invalid for a correct value" unless valid_check
		end

		def valid_enumerized_check_for_correct_value factory
			@valid_enumerized_checks << valid_check = factory.valid?
			@valid_enumerized_errors << "Enumerized field returns invalid for a correct value" unless valid_check
		end

		def valid_enumerized_check_for_incorrect_value factory
			@valid_enumerized_checks << valid_check = factory.invalid?
			@valid_enumerized_errors << "Enumerized field returns valid for a incorrect value" unless valid_check
		end

end
