require "test_helper"

feature "CustomerAdmin" do
  scenario "Index should list only required fields" do
    visit root_path
    page.must_have_content "Customers"
    page.must_have_content "Name"
    page.must_have_content "Email"
    page.must_have_content "Gender"
    page.must_have_content "Phone"
    page.must_have_content "City"
    page.must_have_content "Country"
  end
end
