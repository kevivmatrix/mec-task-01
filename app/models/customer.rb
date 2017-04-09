class Customer < ApplicationRecord
	extend Enumerize

	VALID_GENDERS = %w{ male female }

	VALID_COLORS = %w{ 
		black blue gold green grey indigo ivory green 
		orange pink purple red silver blue white yellow 
	}
	
	enumerize :gender, in: VALID_GENDERS
	enumerize :favorite_colors, in: VALID_COLORS, multiple: true

	validates :age, numericality: { 
		greater_than_or_equal_to: 18,
		less_than_or_equal_to: 99
	}

  def code
    "Customer ##{id}"
  end
end
