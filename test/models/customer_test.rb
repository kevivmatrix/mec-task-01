require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test "Gender field should be enumerized to correct values" do
    desired_genders = %w(male female) 
    assert test_enumerized(:customer, :gender, Customer::VALID_GENDERS, desired_genders)
  end

  test "Favorite colors field should be enumerized to correct values" do
    desired_colors = %w{ 
      black blue gold green grey indigo ivory 
      orange pink purple red silver white yellow 
    }
    assert test_enumerized(:customer, :favorite_colors, Customer::VALID_COLORS, desired_colors)
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
