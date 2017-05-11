class CustomerContactAgeReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

  CSV_COLUMNS = {
    contact_type_name: "Contact Type",
    contact_type_customers_count: "# Customers",
    minimum_age_with_contact_type: "Min. Age",
    maximum_age_with_contact_type: "Max. Age",
    average_age_with_contact_type: "Avg. Age"
  }

  private

    def header
      CSV_COLUMNS.values
    end

    def data_for_csv csv
      contact_types.each do |contact_type|
        data = []
        CSV_COLUMNS.each do |method_name, header|
          data << send(method_name, contact_type)
        end
        csv << data
      end
    end

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
      contact_type_customers(contact_type).average(:age).try(:round, 2)
    end

    def contact_type_customers contact_type
      filtered_data.where("contacts::jsonb ? '#{contact_type}'")
    end

    def apply_filters
      @filtered_data = Customer.ransack(parameters["q"])
      if parameters["order"].present?
        @filtered_data.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
      end
      @filtered_data = @filtered_data.result
    end

end
