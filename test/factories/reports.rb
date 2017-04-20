FactoryGirl.define do
  factory :report do
    type nil
    parameters '{}'
  end

  factory :basic_customer_report do
    type "BasicCustomerReport"
    parameters '{}'
    file nil
  end
end
