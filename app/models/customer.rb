class Customer < ApplicationRecord
	extend Enumerize

	VALID_GENDERS = %w{ male female }

	VALID_COLORS = %w{ 
		black blue gold green grey indigo ivory 
		orange pink purple red silver white yellow 
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

  scope :has_any_of_these_colors_in, ->(*colors) {
		colors = colors.flatten
		where("favorite_colors && '{#{colors.join(",")}}'")
  }

  scope :has_one_of_these_colors, ->(*colors) {
		colors = colors.flatten
		where("favorite_colors @> '{#{colors.join(",")}}'")
  }
  
  def self.ransackable_scopes option
		[ 
			:has_any_of_these_colors_in, 
			:has_one_of_these_colors 
		]
  end
end
