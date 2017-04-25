class BasicCustomerReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	CSV_COLUMNS = %w{ 
		name email phone gender address city
		country zip_code age favorite_colors
		facebook twitter instagram pinterest 
		linkedin reddit google_plus skype slack
		landline mobile	customer_created_at customer_updated_at
	}

	store_accessor *PARAMETERS_STORE_ACCESSOR

	def data_for_csv
		CSV.generate do |csv|
		  csv << CSV_COLUMNS.map(&:titleize)
		  customers = Customer.ransack(parameters["q"])
		  if parameters["order"].present?
		  	customers.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
		  end
		  customers.result.each do |customer|
		  	csv << CSV_COLUMNS.map do |column|
		  		self.send column, customer
		  	end
		  end
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

	private

		def method_missing name, *args
			if CSV_COLUMNS.include? name.to_s
				customer = args[0]
				customer.send name
			else
				super
			end
		end

end
