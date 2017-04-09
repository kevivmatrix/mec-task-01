require "test_helper"

feature "CustomerAdmin" do
  scenario "Index should list only required fields" do
    customer = FactoryGirl.create(:customer)
    visit root_path
    table_header = page.find("#index_table_customers thead")
    table_header.must_have_content "Name"
    table_header.must_have_content "Email"
    table_header.must_have_content "Gender"
    table_header.must_have_content "Phone"
    table_header.must_have_content "City"
    table_header.must_have_content "Country"
    table_header.must_have_content "Favorite Colors"
    table_header.wont_have_content "Id"
    table_header.wont_have_content "Address"
    table_header.wont_have_content "Zip Code"
  end

  scenario "Should list a ID modified field code" do
    customer = FactoryGirl.create(:customer, gender: "male")
    visit root_path
    table_header = page.find("#index_table_customers thead")
    table_header.must_have_content "Code"
    page.must_have_content "Customer ##{customer.id}"
  end

  scenario "Should not give option to download in XML or JSON" do
    customer = FactoryGirl.create(:customer)
    visit root_path
    download_links = page.find("#index_footer .download_links")
    download_links.wont_have_content "XML"
    download_links.wont_have_content "JSON"
  end

  scenario "Download links should be present at top of the page" do
    customer = FactoryGirl.create(:customer)
    visit root_path
    index_header = page.find("#index_header")
    index_header.must_have_content "Download: CSV"
    index_header.must_have_link "CSV", href: admin_customers_path(format: "csv")
  end

  scenario "Should show a result summary on top of listing" do
    customer_1 = FactoryGirl.create(:customer, gender: "male")
    customer_2 = FactoryGirl.create(:customer)
    customer_3 = FactoryGirl.create(:customer)
    visit root_path
    index_header = page.find("#index_header")
    index_header.must_have_content "3 matching Customers"
  end

  feature "Filter Section" do
    scenario "Name should only have Contains filter" do
      visit root_path
      filter_section = page.find("#filters_sidebar_section")
      filter_section.must_have_selector("#q_name_input select", text: "Contains")
      filter_section.wont_have_selector("#q_name_input select", text: "Equals")
      filter_section.wont_have_selector("#q_name_input select", text: "Starts with")
      filter_section.wont_have_selector("#q_name_input select", text: "Ends with")
    end
    scenario "Gender should have all the filters" do
      visit root_path
      filter_section = page.find("#filters_sidebar_section")
      filter_section.must_have_selector("#q_gender_input select", text: "Any")
      filter_section.must_have_selector("#q_gender_input select", text: "Male")
      filter_section.must_have_selector("#q_gender_input select", text: "Female")
    end
    scenario "Favorite colors should have filter" do
      visit root_path
      sample_color_1 = Customer::VALID_COLORS.sample.titleize
      sample_color_2 = Customer::VALID_COLORS.sample.titleize
      filter_section = page.find("#filters_sidebar_section")
      filter_section.must_have_selector("#q_favorite_colors_input select", text: sample_color_1)
      filter_section.must_have_selector("#q_favorite_colors_input select", text: sample_color_2)
    end
    scenario "Other fields should not have filters" do
      visit root_path
      filter_section = page.find("#filters_sidebar_section")
      filter_section.wont_have_css("#q_email_input")
      filter_section.wont_have_css("#q_phone_input")
      filter_section.wont_have_css("#q_address_input")
      filter_section.wont_have_css("#q_city_input")
      filter_section.wont_have_css("#q_country_input")
      filter_section.wont_have_css("#q_zip_code_input")
      filter_section.wont_have_css("#q_created_at_input")
      filter_section.wont_have_css("#q_updated_at_input")
    end
    scenario "Select multiple favorite colors" do
      customer_1 = FactoryGirl.create(:customer, favorite_colors: [ "black", "red" ])
      customer_2 = FactoryGirl.create(:customer, favorite_colors: [ "pink", "blue" ])
      customer_2 = FactoryGirl.create(:customer, favorite_colors: [ "yellow", "green" ])
      customer_3 = FactoryGirl.create(:customer, favorite_colors: [ "white", "purple" ])
      visit root_path
      filter_section = page.find("#filters_sidebar_section")
      filter_section.must_have_content "Select Multiple Favorite Colors"
      filter_section.find(:css, "#q_by_favorite_colors_black").set(true)
      filter_section.find(:css, "#q_by_favorite_colors_green").set(true)
      filter_section.find("input[type='submit']").click
      listing_section = page.find("#index_table_customers tbody")
      listing_section.must_have_content("black")
      listing_section.must_have_content("red")
      listing_section.must_have_content("yellow")
      listing_section.must_have_content("green")
      listing_section.wont_have_content("pink")
      listing_section.wont_have_content("blue")
      listing_section.wont_have_content("white")
      listing_section.wont_have_content("purple")
    end
  end
end
