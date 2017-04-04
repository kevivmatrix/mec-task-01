require "test_helper"

feature "CustomerAdmin" do
  scenario "Index should list only required fields" do
    visit root_path
    table_header = page.find("#index_table_customers thead")
    table_header.must_have_content "Name"
    table_header.must_have_content "Email"
    table_header.must_have_content "Gender"
    table_header.must_have_content "Phone"
    table_header.must_have_content "City"
    table_header.must_have_content "Country"
    table_header.wont_have_content "Id"
    table_header.wont_have_content "Address"
    table_header.wont_have_content "Zip Code"
  end
end
