class Customer < ApplicationRecord
	extend Enumerize

	VALID_GENDERS = %w{ male female }
	
	enumerize :gender, in: VALID_GENDERS

	validates :age, numericality: { 
		greater_than_or_equal_to: 18,
		less_than_or_equal_to: 99
	}

  def code
    "Customer ##{id}"
  end
end
