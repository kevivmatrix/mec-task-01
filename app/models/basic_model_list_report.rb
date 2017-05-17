class BasicModelListReport < Report

	private

		def column_methods
			self.class.csv_columns.keys
		end

		def formatted_data_batch &block
			ids = core_data.result.ids
			ids.each_slice(self.class.batch_size) do |chunk|
				yield chunk
			end
    end

    def data_for_csv csv
		  formatted_data_batch do |chunk|
		    self.class.core_scope.find(chunk).each do |customer|
		    	generate_row csv, customer
		    end
			end
		end

    def generate_row csv, model
    	csv << column_methods.map do |column|
	  		send column, model
	  	end
    end

    def method_missing name, *args
			if column_methods.include? name
				customer = args[0]
				customer.send name
			else
				super
			end
		end

end
