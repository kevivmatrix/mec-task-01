class CustomerColorReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

  def self.csv_columns
    {
      color_name: "Color",
      color_customers_count: "# Customers favorited",
      unique_color_customers_count: "# Customers only favorited"
    }
  end

  def self.core_scope
    Customer.all
  end
  
  private

    def data_for_csv csv
      colors.each do |color|
        data = []
        self.class.csv_columns.each do |method_name, header|
          data << send(method_name, color)
        end
        csv << data
      end
      empty_row(csv)
      add_row(csv, "Average # of Colors per Customer", average_number_of_colors_per_customer)
      add_row(csv, "Average # of Customers per Color", average_number_of_customers_per_color)
    end

    def color_name color
      color
    end

    def color_customers_count color
      core_data_result.where("favorite_colors && '{#{color}}'").count
    end

    def unique_color_customers_count color
      core_data_result.where("favorite_colors = '{#{color}}'").count
    end

    def average_number_of_colors_per_customer
      (total_colors_set_by_customers / customers_count.to_f).round(3)
    end

    def average_number_of_customers_per_color
      (customers_with_colors_count / colors.count.to_f).round(3)
    end

    def apply_filters
      @core_data = Customer.ransack(parameters["q"])
    end

    def colors
      Customer::VALID_COLORS
    end

    def customers_with_colors_count
      core_data_result.where("favorite_colors != '{}'").count
    end

    def customers_count
      core_data_result.count
    end

    def total_colors_set_by_customers
      core_data_result.sum("array_length(favorite_colors, 1)")
    end

    def core_data_result
      @core_data_result ||= core_data.result
    end

end
