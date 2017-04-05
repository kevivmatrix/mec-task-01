class Customer < ApplicationRecord
	extend Enumerize

	VALID_GENDERS = %w{ male female }
	
	enumerize :gender, in: VALID_GENDERS

  def code
    "Customer ##{id}"
  end
end
