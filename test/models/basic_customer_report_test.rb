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
		assert_equal "basic_customer_report_#{basic_customer_report.id.to_s}.csv", generated_file_name
	end

	test "Data for csv" do
		customer_1 = FactoryGirl.create :customer, favorite_colors: ["red", "orange"], contacts: { facebook: "facebook1" }
		customer_2 = FactoryGirl.create :customer, favorite_colors: ["yellow", "green"], contacts: { skype: "skype1" }
		basic_customer_report = FactoryGirl.create :basic_customer_report
		
		csv_data = basic_customer_report.generate_csv
		csv_data_lines = csv_data.split("\n")
		csv_columns = BasicCustomerReport.csv_columns
		titleized_csv_columns = csv_columns.values.join(",")

		customer_1_data = CSV.generate do |csv|
	  	csv << BasicCustomerReport.csv_columns.keys.map do |column|
	  		basic_customer_report.send column, customer_1
	  	end
		end

		customer_2_data = CSV.generate do |csv|
	  	csv << BasicCustomerReport.csv_columns.keys.map do |column|
	  		basic_customer_report.send column, customer_2
	  	end
		end
		
		assert_equal titleized_csv_columns, csv_data_lines[0]
		assert_equal customer_1_data.strip, csv_data_lines[1]
		assert_equal customer_2_data.strip, csv_data_lines[2]
	end

end
