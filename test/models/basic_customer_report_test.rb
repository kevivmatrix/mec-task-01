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

	test "Favorite Colors" do
		customer = FactoryGirl.create :customer, favorite_colors: [ "red", "yellow" ]
		basic_customer_report = FactoryGirl.create :basic_customer_report
		assert_equal basic_customer_report.favorite_colors(customer), "red, yellow"
	end

	test "Time fields - created_at and updated_at" do
		customer = FactoryGirl.create :customer
		basic_customer_report = FactoryGirl.create :basic_customer_report
		assert_equal basic_customer_report.customer_created_at(customer), customer.created_at
		assert_equal basic_customer_report.customer_updated_at(customer), customer.updated_at
	end

end
