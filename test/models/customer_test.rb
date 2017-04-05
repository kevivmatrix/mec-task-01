require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
	test "VALID_GENDERS constant should return male and female in a array" do
		assert_equal Customer::VALID_GENDERS, [ "male", "female" ]
	end

  test "Gender field should contain value from VALID GENDER constant" do
  	sample_gender_value = Customer::VALID_GENDERS.sample
    valid_gender_customer = FactoryGirl.create(:customer, gender: sample_gender_value)
    assert valid_gender_customer.valid?

    invalid_gender_customer = Faker::Lorem.word
    assert_raises(ActiveRecord::RecordInvalid) do
    	FactoryGirl.create(:customer, gender: invalid_gender_customer)
    end
  end
end
