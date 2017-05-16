class BasicCustomerReport < BasicModelListReport

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR
	
	def self.csv_columns
		{
			name: "Name",
			email: "Email",
			phone: "Phone",
			gender: "Gender",
			address: "Address",
			city: "City",
			country: "Country",
			zip_code: "ZipCode",
			age: "Age",
			favorite_colors: "FavoriteColors",
			facebook: "Facebook",
			twitter: "Twitter",
			instagram: "Instagram",
			pinterest: "Pinterest",
			linkedin: "Linkedin",
			reddit: "Reddit",
			google_plus: "GooglePlus",
			skype: "Skype",
			slack: "Slack",
			landline: "Landline",
			mobile: "Mobile",
			customer_created_at: "Created At",
			customer_updated_at: "Updated At"
		}
	end

	def self.core_scope
    Customer.includes(:city, :customer_type).all
  end

	private

		def favorite_colors customer
			customer.favorite_colors.join(", ")
		end

		def customer_created_at customer
			customer.created_at
		end

		def customer_updated_at customer
			customer.updated_at
		end

		def city customer
			customer.city.name
		end

end
