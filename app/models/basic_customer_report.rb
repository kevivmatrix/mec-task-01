class BasicCustomerReport < Report

	PARAMETERS = []

	PARAMETERS_STORE_ACCESSOR = [ :parameters ] + PARAMETERS

	store_accessor *PARAMETERS_STORE_ACCESSOR

	def generate
		
	end

end
