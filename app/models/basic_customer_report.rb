class BasicCustomerReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

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

	store_accessor *PARAMETERS_STORE_ACCESSOR

	private

		def header
			self.class.csv_columns.values
		end

		def data_for_csv csv
		  formatted_data_batch do |chunk|
		    Customer.includes(:city, :customer_type).find(chunk).each do |customer|
		    	csv << self.class.csv_columns.keys.map do |column|
			  		send column, customer
			  	end
		    end
			end
		end

		def apply_filters
      @filtered_data = Customer.includes(:city, :customer_type).
      							ransack(parameters["q"])
      if parameters["order"].present?
        @filtered_data.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
      end
    end

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

		def method_missing name, *args
			if self.class.csv_columns.keys.include? name
				customer = args[0]
				customer.send name
			else
				super
			end
		end

end
