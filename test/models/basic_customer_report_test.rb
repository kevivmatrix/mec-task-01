require "test_helper"

class BasicCustomerReportTest < ActiveSupport::TestCase

	test "Generate" do
		basic_customer_report = FactoryGirl.create :basic_customer_report
		# Before Generate
		assert basic_customer_report.file.url.nil?
		# Generate
		basic_customer_report.generate("csv")
		# Check generated file
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

	test "Data for csv" do
		customer_1 = FactoryGirl.create :customer, favorite_colors: ["red", "orange"], contacts: { facebook: "facebook1" }
		customer_2 = FactoryGirl.create :customer, favorite_colors: ["yellow", "green"], contacts: { skype: "skype1" }
		basic_customer_report = FactoryGirl.create :basic_customer_report
		
		csv_data = basic_customer_report.data_for_csv
		csv_data_lines = csv_data.split("\n")
		csv_columns = BasicCustomerReport::CSV_COLUMNS
		titleized_csv_columns = csv_columns.map(&:titleize).join(",")

		customer_1_data = CSV.generate do |csv|
	  	csv << BasicCustomerReport::CSV_COLUMNS.map do |column|
	  		basic_customer_report.send column, customer_1
	  	end
		end

		customer_2_data = CSV.generate do |csv|
	  	csv << BasicCustomerReport::CSV_COLUMNS.map do |column|
	  		basic_customer_report.send column, customer_2
	  	end
		end
		
		assert_equal csv_data_lines[0], titleized_csv_columns
		assert_equal csv_data_lines[1], customer_1_data.strip
		assert_equal csv_data_lines[2], customer_2_data.strip
	end

end
