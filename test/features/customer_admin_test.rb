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

  scenario "Download links should be present at top of the page" do
    visit root_path

  end

  scenario "Should show a result summary on top of listing" do
    visit root_path
    index_header = page.find("#index_header")
    index_header.must_have_content "2 matching Customers"
  end

  feature "Filters" do
    scenario "Name should only have contains filter" do
      visit root_path
      filter_section = page.find("#filters_sidebar_section")
      filter_section.must_have_select
    end
  end
end
