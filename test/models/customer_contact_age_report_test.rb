require "test_helper"

class CustomerContactAgeReportTest < ActiveSupport::TestCase

	test "Generate" do
		customer_contact_age_report = FactoryGirl.create :customer_contact_age_report
		# Before Generate
		assert customer_contact_age_report.file.url.nil?
		# Generate
		customer_contact_age_report.generate
		# Check generated file
		assert customer_contact_age_report.file.present?
		generated_file_name = File.basename customer_contact_age_report.file.url
		assert_equal "customer_contact_age_report_#{customer_contact_age_report.id.to_s}.csv", generated_file_name
	end

	test "Data for csv" do
		customer_1 = FactoryGirl.create :customer, age: 43, contacts: { facebook: "facebook1" }
		customer_2 = FactoryGirl.create :customer, age: 32, contacts: { facebook: "facebook2", twitter: "twitter2" }
		customer_3 = FactoryGirl.create :customer, age: 38, contacts: { instagram: "instagram3", twitter: "twitter3" }
		customer_4 = FactoryGirl.create :customer, age: 50, contacts: { google_plus: "google_plus4", skype: "skype3" }
		customer_5 = FactoryGirl.create :customer, age: 21, contacts: { skype: "instagram5", twitter: "twitter5" }
		customer_6 = FactoryGirl.create :customer, age: 67, contacts: { landline: "landline6", linkedin: "linkedin6" }
		customer_contact_age_report = FactoryGirl.create :customer_contact_age_report

		customer_contact_age_report.generate
		csv_data_lines = customer_contact_age_report.file.file.read.split("\n")

		assert_equal "Contact Type,# Customers,Min. Age,Max. Age,Avg. Age", csv_data_lines[0]
		assert_equal "facebook,2,32,43,37.5", csv_data_lines[1]
		assert_equal "twitter,3,21,38,30.33", csv_data_lines[2]
		assert_equal "instagram,1,38,38,38.0", csv_data_lines[3]
		assert_equal "pinterest,0,,,", csv_data_lines[4]
		assert_equal "linkedin,1,67,67,67.0", csv_data_lines[5]
		assert_equal "reddit,0,,,", csv_data_lines[6]
		assert_equal "google_plus,1,50,50,50.0", csv_data_lines[7]
		assert_equal "skype,2,21,50,35.5", csv_data_lines[8]
		assert_equal "slack,0,,,", csv_data_lines[9]
		assert_equal "landline,1,67,67,67.0", csv_data_lines[10]
		assert_equal "mobile,0,,,", csv_data_lines[11]
	end

end
