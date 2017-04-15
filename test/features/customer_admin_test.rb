require "test_helper"

feature "CustomerAdmin" do
  scenario "Index should list only required fields" do
    customer = FactoryGirl.create(:customer)
    visit root_path
    table_header = page.find("#index_table_customers thead")
    table_header.must_have_content "Name"
    table_header.must_have_content "Email"
    table_header.must_have_content "Phone"
    table_header.must_have_content "City"
    table_header.must_have_content "Country"
    table_header.must_have_content "Favorite Colors"
    table_header.must_have_content "Gender"
    table_header.must_have_content "Contacts"
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
    feature "Favorite colors filters" do
      scenario "Single Select filter" do
        customer_1 = FactoryGirl.create(:customer, favorite_colors: [ "black", "red" ])
        customer_2 = FactoryGirl.create(:customer, favorite_colors: [ "pink", "blue" ])
        visit root_path
        sample_color_1 = Customer::VALID_COLORS.sample
        sample_color_2 = Customer::VALID_COLORS.sample
        filter_section = page.find("#filters_sidebar_section")
        filter_section.find("#q_has_one_of_these_colors option[value='black']").select_option
        filter_section.find("input[type='submit']").click
        listing_section = page.find("#index_table_customers tbody")
        listing_section.must_have_content("black")
        listing_section.must_have_content("red")
        listing_section.wont_have_content("pink")
        listing_section.wont_have_content("blue")
      end
      scenario "Multiple Checkbox filter" do
        customer_1 = FactoryGirl.create(:customer, favorite_colors: [ "black", "red" ])
        customer_2 = FactoryGirl.create(:customer, favorite_colors: [ "pink", "blue" ])
        customer_2 = FactoryGirl.create(:customer, favorite_colors: [ "yellow", "green" ])
        customer_3 = FactoryGirl.create(:customer, favorite_colors: [ "white", "purple" ])
        visit root_path
        filter_section = page.find("#filters_sidebar_section")
        filter_section.find(:css, "#q_has_any_of_these_colors_black").set(true)
        filter_section.find(:css, "#q_has_any_of_these_colors_green").set(true)
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
      scenario "Has all of these contact types" do
        customer_1 = FactoryGirl.create(:customer, name: "Customer 1", contacts: { facebook: "facebook1", skype: "skype1" })
        customer_2 = FactoryGirl.create(:customer, name: "Customer 2", contacts: { facebook: "facebook2", twitter: "twitter1" })
        customer_2 = FactoryGirl.create(:customer, name: "Customer 3", contacts: { facebook: "facebook3", skype: "skype2", twitter: "twitter2" })
        visit root_path
        filter_section = page.find("#filters_sidebar_section")
        filter_section.find("#q_has_all_of_these_contact_types option[value='facebook']").select_option
        filter_section.find("#q_has_all_of_these_contact_types option[value='skype']").select_option
        filter_section.find("input[type='submit']").click
        listing_section = page.find("#index_table_customers tbody")
        listing_section.must_have_content("Customer 1")
        listing_section.wont_have_content("Customer 2")
        listing_section.must_have_content("Customer 3")
      end
      scenario "Has contact which contains" do
        customer_1 = FactoryGirl.create(:customer, name: "Customer 1", contacts: { facebook: "facebook1", skype: "skype1" })
        customer_2 = FactoryGirl.create(:customer, name: "Customer 2", contacts: { facebook: "facebook2", twitter: "twitter1" })
        visit root_path
        filter_section = page.find("#filters_sidebar_section")
        filter_section.find("#q_has_contact_which_contains").set("twitter1")
        filter_section.find("input[type='submit']").click
        listing_section = page.find("#index_table_customers tbody")
        listing_section.wont_have_content("Customer 1")
        listing_section.must_have_content("Customer 2")
      end
    end
  end

  feature "Edit" do
    scenario "Contact types" do
      customer_1 = FactoryGirl.create(:customer)
      visit root_path
      listing_section = page.find("#index_table_customers tbody")
      listing_section.find("a", text: "Edit").click
      listing_section.wont_have_content("facebook1")
      listing_section.wont_have_content("skype1")
      page.find("#customer_facebook").set "facebook1"
      page.find("#customer_skype").set "skype1"
      page.find("#customer_submit_action input").click
      listing_section = page.find("#index_table_customers tbody")
      listing_section.must_have_content("facebook1")
      listing_section.must_have_content("skype1")
    end
  end
end
