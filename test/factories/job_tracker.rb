FactoryGirl.define do
  factory :job_tracker do
    association :trackable, factory: :basic_customer_report
  end
end
