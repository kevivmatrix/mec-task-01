require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test "Gender field should be enumerized to correct values" do
    desired_genders = %w(male female)
    result = valid_enumerized(:customer, :gender, Customer::VALID_GENDERS, desired_genders)
    assert result.valid, result.messages.first
  end

  test "Favorite colors field should be enumerized to correct values" do
    desired_colors = %w{ 
      black blue gold green grey indigo ivory 
      orange pink purple red silver white yellow 
    }
    result = valid_enumerized(:customer, :favorite_colors, Customer::VALID_COLORS, desired_colors, true)
    assert result.valid, result.messages.first
  end
  
  test "Age should be within 18 and 99" do
    valid_age_customer = FactoryGirl.build(:customer, age: 19)
    assert valid_age_customer.valid?

    invalid_underage_customer = FactoryGirl.build(:customer, age: 17)
    assert invalid_underage_customer.invalid?
    assert_equal ["must be greater than or equal to 18"], invalid_underage_customer.errors[:age]

    invalid_overage_customer = FactoryGirl.build(:customer, age: 100)
    assert invalid_overage_customer.invalid?
    assert_equal ["must be less than or equal to 99"], invalid_overage_customer.errors[:age]
  end

end
