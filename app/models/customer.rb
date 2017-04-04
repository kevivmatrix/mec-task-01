class Customer < ApplicationRecord
	extend Enumerize
	
	enumerize :sex, in: [:male, :female]
end
