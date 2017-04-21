require "test_helper"

class BasicCustomerReportTest < ActiveSupport::TestCase

	test "Generate" do
		basic_customer_report = FactoryGirl.create :basic_customer_report
		# Before Generate
		assert basic_customer_report.pending?
		assert basic_customer_report.file.url.nil?
		# Generate
		basic_customer_report.generate("csv")
		# Check generated file
		assert basic_customer_report.complete?
		assert basic_customer_report.file.present?
		generated_file_name = File.basename basic_customer_report.file.url
		assert_equal generated_file_name, "report_#{basic_customer_report.id.to_s}.csv"
	end

end
