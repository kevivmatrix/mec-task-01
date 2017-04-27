class CustomerContactAgeReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

  attr_accessor :customers

  CSV_COLUMNS = {
    contact_type_name: "Contact Type",
    contact_type_customers_count: "# Customers",
    minimum_age_with_contact_type: "Min. Age",
    maximum_age_with_contact_type: "Max. Age",
    average_age_with_contact_type: "Avg. Age"
  }

	def data_for_csv
    set_customers
		CSV.generate do |csv|
		  csv << CSV_COLUMNS.values
      contact_types.each do |contact_type|
        data = []
        CSV_COLUMNS.each do |method_name, header|
          data << send(method_name, contact_type)
        end
        csv << data
      end
		end
	end

  private

    def contact_types
      Customer::CONTACT_TYPES
    end

    def contact_type_name contact_type
      contact_type
    end

    def contact_type_customers_count contact_type
      contact_type_customers(contact_type).count
    end

    def minimum_age_with_contact_type contact_type
      contact_type_customers(contact_type).minimum(:age)
    end

    def maximum_age_with_contact_type contact_type
      contact_type_customers(contact_type).maximum(:age)
    end

    def average_age_with_contact_type contact_type
      contact_type_customers(contact_type).average(:age)
    end

    def contact_type_customers contact_type
      customers.where("contacts::jsonb ? '#{contact_type}'")
    end

    def set_customers
      @customers = Customer.ransack(parameters["q"])
      if parameters["order"].present?
        @customers.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
      end
      @customers = @customers.result
    end

    def temp_report_file_path format
      Rails.root.join("tmp", "customer_contact_age_report_#{self.id}.#{format}")
    end

end
