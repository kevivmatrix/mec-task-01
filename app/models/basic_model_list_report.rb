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
    	model_index = 0
		  formatted_data_batch do |chunk|
		    self.class.core_scope.find(chunk).each do |model|
		    	generate_row csv, model
		    end
				model_index += chunk.size
				if model_index % 1000 == 0 || core_data_count < 1000
					track_active_job( (model_index / core_data_count.to_f) * 100 )
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
				model = args[0]
				model.send name
			else
				super
			end
		end

end
