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

  scenario "Should list a ID modified field code" do
    customer_1 = Customer.take
    visit root_path
    table_header = page.find("#index_table_customers thead")
    table_header.must_have_content "Code"
    page.must_have_content "Customer ##{customer_1.id}"
  end

  scenario "Should not give option to download in XML or JSON" do
    visit root_path
    download_links = page.find("#index_footer .download_links")
    download_links.wont_have_content "XML"
    download_links.wont_have_content "JSON"
  end
end
