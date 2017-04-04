class Customer < ApplicationRecord
	extend Enumerize
	
	enumerize :sex, in: [:male, :female]

  def code
    "Customer ##{id}"
  end
end
