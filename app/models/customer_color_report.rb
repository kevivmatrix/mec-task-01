class CustomerColorReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

  CSV_COLUMNS = {
    color_name: "Color",
    customers_count: "# Customers favorited",
    unique_customers_count: "# Customers only favorited"
  }

	def data_for_csv
		CSV.generate do |csv|
      csv << CSV_COLUMNS.values
      Customer::VALID_COLORS.each do |color|
        data = []
		    CSV_COLUMNS.each do |method_name, header|
          data << send(method_name, color)
        end
        csv << data
      end
		end
	end

  def color_name color
    color
  end

  def customers_count color
    Customer.where("favorite_colors && '{#{color}}'").count
  end

  def unique_customers_count color
    Customer.where("favorite_colors = '{#{color}}'").count
  end

  private

    def temp_report_file_path format
      Rails.root.join("tmp", "customer_color_report_#{self.id}.#{format}")
    end

end
