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

  factory :customer_color_report do
    type "CustomerColorReport"
    parameters '{}'
    file nil
  end

  factory :customer_contact_age_report do
    type "CustomerContactAgeReport"
    parameters '{}'
    file nil
  end
end
