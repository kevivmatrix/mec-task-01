FactoryGirl.define do
  factory :customer_type do
    sequence :name do |n|
      "Customer Type #{n}"
    end
  end
end
