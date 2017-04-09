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

  ransacker :single_favorite_color, formatter: ->(color) {
    data = where("'#{color}' = ANY(favorite_colors)").ids
    data.present? ? data : nil
  } do |parent|
    parent.table[:id]
  end

  ransacker :multiple_favorite_colors, formatter: ->(color) {
  	data = where("'#{color}' = ANY(favorite_colors)").ids
  	data.present? ? data : nil
	} do |parent|
	  parent.table[:id]
	end
end
