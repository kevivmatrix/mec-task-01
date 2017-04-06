require 'test_helper'

class CustomerTest < ActiveSupport::TestCase

  test "Gender field should be enumerized to correct values"  do
    desired_genders = %w(male female) 
    assert_equal Customer::VALID_GENDERS.sort, desired_genders.sort   #should add .sort if we don't care about order
    desired_genders.each do |gender|
      assert FactoryGirl.build(:customer, gender: gender).valid?
    end
    invalid_customer = FactoryGirl.build(:customer, gender: Faker::Lorem.word)
    assert invalid_customer.invalid?
    assert invalid_customer.errors.keys.include?(:gender)
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
