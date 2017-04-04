class Customer < ApplicationRecord
	extend Enumerize
	
	enumerize :gender, in: [:male, :female]

  def code
    "Customer ##{id}"
  end
end
