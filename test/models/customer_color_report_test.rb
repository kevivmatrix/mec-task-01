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
		customer_3 = FactoryGirl.create :customer, favorite_colors: ["green"]
		customer_4 = FactoryGirl.create :customer, favorite_colors: ["black", "orange"]
		customer_5 = FactoryGirl.create :customer, favorite_colors: ["orange"]
		customer_6 = FactoryGirl.create :customer, favorite_colors: []
		customer_color_report = FactoryGirl.create :customer_color_report

		csv_data = customer_color_report.generate_csv
		csv_data_lines = csv_data.split("\n")

		assert_equal "Color,# Customers favorited,# Customers only favorited", csv_data_lines[0]
		assert_equal "black,1,0", csv_data_lines[1]
		assert_equal "blue,0,0", csv_data_lines[2]
		assert_equal "gold,0,0", csv_data_lines[3]
		assert_equal "green,2,1", csv_data_lines[4]
		assert_equal "grey,0,0", csv_data_lines[5]
		assert_equal "indigo,0,0", csv_data_lines[6]
		assert_equal "ivory,0,0", csv_data_lines[7]
		assert_equal "orange,3,1", csv_data_lines[8]
		assert_equal "pink,0,0", csv_data_lines[9]
		assert_equal "purple,0,0", csv_data_lines[10]
		assert_equal "red,1,0", csv_data_lines[11]
		assert_equal "silver,0,0", csv_data_lines[12]
		assert_equal "white,0,0", csv_data_lines[13]
		assert_equal "yellow,1,0", csv_data_lines[14]
		assert_equal "", csv_data_lines[15]
		assert_equal "Average # of Colors per Customer,1.333", csv_data_lines[16]
		assert_equal "Average # of Customers per Color,0.357", csv_data_lines[17]
	end

end
