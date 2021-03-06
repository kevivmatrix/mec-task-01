class Customer < ApplicationRecord
	extend Enumerize

	VALID_GENDERS = %w{ male female }

	VALID_COLORS = %w{ 
		black blue gold green grey indigo ivory 
		orange pink purple red silver white yellow 
	}

	# Modify contact types here
	CONTACT_TYPES = [
		:facebook, :twitter, :instagram, :pinterest, 
		:linkedin, :reddit, :google_plus, :skype, :slack,
		:landline, :mobile
	]

	CONTACT_TYPES_STORE_ACCESSOR = [ :contacts ] + CONTACT_TYPES

  belongs_to :city
  belongs_to :customer_type
	
	enumerize :gender, in: VALID_GENDERS
	enumerize :favorite_colors, in: VALID_COLORS, multiple: true

	store_accessor *CONTACT_TYPES_STORE_ACCESSOR

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

  scope :has_all_of_these_contact_types, ->(*contact_types){
  	contact_types = contact_types.flatten.reject(&:blank?).map do |contact_type|
  		"'#{contact_type}'"
  	end
  	where("contacts::jsonb ?& array[#{contact_types.join(",")}]")
  }

  scope :has_contact_which_contains, ->(contact_value){
  	query = Customer::CONTACT_TYPES.map do |contact_type|
  		%Q{ contacts ->> '#{contact_type}' ilike '%#{contact_value}%' }
  	end
  	where(query.join(" OR "))
  }
  
  def self.ransackable_scopes option
		[ 
			:has_any_of_these_colors_in, 
			:has_one_of_these_colors,
			:has_all_of_these_contact_types,
			:has_contact_which_contains
		]
  end
end
