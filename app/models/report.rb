class Report < ApplicationRecord
	extend Enumerize
	
	VALID_STATUSES = %w{ pending processing complete }

	enumerize :status, in: VALID_STATUSES, default: "pending"

	def generate format="csv"
		data = send("data_for_#{format}")
		# store in file
	end
end
