require "test_helper"

class CustomerColorReportTest < ActiveSupport::TestCase

	test "Generate" do
		customer_color_report = FactoryGirl.create :customer_color_report
		# Before Generate
		assert customer_color_report.file.url.nil?
		# Generate
		customer_color_report.generate("csv")
		# Check generated file
		assert customer_color_report.file.present?
		generated_file_name = File.basename customer_color_report.file.url
		assert_equal "customer_color_report_#{customer_color_report.id.to_s}.csv", generated_file_name
	end

	test "Data for csv" do
		customer_1 = FactoryGirl.create :customer, favorite_colors: ["red", "orange"]
		customer_2 = FactoryGirl.create :customer, favorite_colors: ["yellow", "green"]
		customer_color_report = FactoryGirl.create :customer_color_report

		csv_data = customer_color_report.data_for_csv
		csv_data_lines = csv_data.split("\n")

		assert_equal csv_data_lines
	end

end
