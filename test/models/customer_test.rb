require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
	test "VALID_GENDERS constant should return male and female in a array" do
		assert_equal Customer::VALID_GENDERS, [ "male", "female" ]
	end

  test "Gender field should contain value from VALID GENDER constant" do
  	sample_gender_value = Customer::VALID_GENDERS.sample
    valid_gender_customer = FactoryGirl.create(:customer, gender: sample_gender_value)
    assert valid_gender_customer.valid?

    invalid_gender_value = Faker::Lorem.word
    invalid_gender_customer = FactoryGirl.build(:customer, gender: invalid_gender_value)
    assert invalid_gender_customer.invalid?
    assert_equal invalid_gender_customer.errors[:gender], ["is not included in the list"]
  end

  test "Age should be within 18 and 99" do
    valid_age_customer = FactoryGirl.build(:customer, age: 19)
    assert valid_age_customer.valid?

    invalid_underage_customer = FactoryGirl.build(:customer, age: 17)
    assert invalid_underage_customer.invalid?
    assert_equal invalid_underage_customer.errors[:age], ["must be greater than or equal to 18"]

    invalid_overage_customer = FactoryGirl.build(:customer, age: 100)
    assert invalid_overage_customer.invalid?
    assert_equal invalid_overage_customer.errors[:age], ["must be less than or equal to 99"]
  end
end
