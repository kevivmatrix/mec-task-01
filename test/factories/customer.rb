FactoryGirl.define do
  factory :customer do
    sequence :name do |n|
      "Customer #{n}"
    end
    sequence :email do |n|
      "customer.#{n}@test.com"
    end
    phone "123456789"
    gender "female"
    address "Address 123"
    association :city, factory: :city
    country "Country"
    zip_code "123456"
    age 21
  end
end
