require 'active_support/test_case'
require 'ostruct'

class ActiveSupport::TestCase

  def setup_customers
    FactoryGirl.create(:customer, 
      favorite_colors: ["red", "orange"], zip_code: "11101", age: 21,
      name: "Customer 1", email: "customer_1@gmail.com", phone: "1234", gender: "male",
      address: "Customer 1 Address", city: "New York", country: "USA",
      contacts: { 
        facebook: "facebook1", twitter: "twitter1", instagram: "instagram1",
        pinterest: "pinterest1", linkedin: "linkedin1", reddit: "reddit1", 
        google_plus: "google_plus1", skype: "skype1", slack: "slack1",
        landline: "landline1", mobile: "mobile1"
      }
    )
    FactoryGirl.create(:customer, 
      favorite_colors: ["black", "green"], zip_code: "11102", age: 32,
      name: "Customer 2", email: "customer_2@gmail.com", phone: "4567", gender: "male",
      address: "Customer 2 Address", city: "California", country: "USA",
      contacts: { 
        facebook: "facebook2", twitter: "twitter2", instagram: "instagram2",
        pinterest: "pinterest2", linkedin: "linkedin2", reddit: "reddit2", 
        google_plus: "google_plus2", skype: "skype2", slack: "slack2",
        landline: "landline2", mobile: "mobile2"
      }
    )
    FactoryGirl.create(:customer, 
      favorite_colors: ["blue", "green"], zip_code: "11103", age: 43,
      name: "Customer 3", email: "customer_3@gmail.com", phone: "7890", gender: "female",
      address: "Customer 3 Address", city: "Washington", country: "USA",
      contacts: { 
        facebook: "facebook3", twitter: "twitter3", instagram: "instagram3",
        pinterest: "pinterest3", linkedin: "linkedin3", reddit: "reddit3", 
        google_plus: "google_plus3", skype: "skype3", slack: "slack3",
        landline: "landline3", mobile: "mobile3"
      }
    )
    Customer.all
  end
end
