class Report < ApplicationRecord
	extend Enumerize
	
	VALID_STATUSES = %w{ pending processing complete }

	enumerize :status, in: VALID_STATUSES, default: "pending"
end
