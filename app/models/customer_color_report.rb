class CustomerColorReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

  attr_accessor :customers

  CSV_COLUMNS = {
    color_name: "Color",
    color_customers_count: "# Customers favorited",
    unique_color_customers_count: "# Customers only favorited"
  }

	def data_for_csv
    set_customers
		CSV.generate do |csv|
      csv << CSV_COLUMNS.values
      colors.each do |color|
        data = []
		    CSV_COLUMNS.each do |method_name, header|
          data << send(method_name, color)
        end
        csv << data
      end
      csv << []
      csv << [ "Average # of Colors per Customer", average_number_of_colors_per_customer ]
      csv << [ "Average # of Customers per Color", average_number_of_customers_per_color ]
		end
	end

  private

    def color_name color
      color
    end

    def color_customers_count color
      customers.where("favorite_colors && '{#{color}}'").count
    end

    def unique_color_customers_count color
      customers.where("favorite_colors = '{#{color}}'").count
    end

    def average_number_of_colors_per_customer
      (total_colors_set_by_customers / customers_count.to_f).round(3)
    end

    def average_number_of_customers_per_color
      (customers_with_colors_count / colors.count.to_f).round(3)
    end

    def set_customers
      @customers = Customer.ransack(parameters["q"])
      if parameters["order"].present?
        @customers.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
      end
      @customers = @customers.result
    end

    def colors
      Customer::VALID_COLORS
    end

    def customers_with_colors_count
      customers.where("favorite_colors != '{}'").count
    end

    def customers_count
      customers.count
    end

    def total_colors_set_by_customers
      customers.sum("array_length(favorite_colors, 1)")
    end

end
