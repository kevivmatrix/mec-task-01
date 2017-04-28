require "test_helper"

class CustomerContactAgeReportTest < ActiveSupport::TestCase

	test "Generate" do
		customer_contact_age_report = FactoryGirl.create :customer_contact_age_report
		# Before Generate
		assert customer_contact_age_report.file.url.nil?
		# Generate
		customer_contact_age_report.generate("csv")
		# Check generated file
		assert customer_contact_age_report.file.present?
		generated_file_name = File.basename customer_contact_age_report.file.url
		assert_equal "customer_contact_age_report_#{customer_contact_age_report.id.to_s}.csv", generated_file_name
	end

	test "Data for csv" do
		
	end

end
