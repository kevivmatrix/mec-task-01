class CustomerColorReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

	def data_for_csv
		CSV.generate do |csv|
		  
		end
	end

end
