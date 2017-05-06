# Customer Type
CustomerType.create(name: "A")
CustomerType.create(name: "B")
CustomerType.create(name: "C")

customer_type_ids = CustomerType.ids

# City data
100.times do
	City.create(
		name: Faker::Address.city
	)
end

city_ids = City.ids

# Customer Sample Data
100_000.times do
	Customer.create(
		name: 		Faker::Name.name,
		email: 		Faker::Internet.email,
		phone: 		Faker::PhoneNumber.phone_number,
		gender:   Faker::Boolean.boolean ? "male" : "female",
		address: 	"#{Faker::Address.secondary_address}, #{Faker::Address.street_name}, #{Faker::Address.street_address}",	
		city_id: 	city_ids.sample,
		customer_type_id: customer_type_ids.sample,
		country: 	Faker::Address.country,
		zip_code: Faker::Address.zip_code,
		age:      Faker::Number.between(18, 99),
		favorite_colors: Customer::VALID_COLORS.sample(2),
		contacts: {
			facebook: Faker::Internet.user_name,
			twitter: Faker::Internet.user_name,
			instagram: Faker::Internet.user_name,
			pinterest: Faker::Internet.user_name,
			linkedin: Faker::Internet.user_name,
			reddit: Faker::Internet.user_name,
			google_plus: Faker::Internet.user_name,
			skype: Faker::Internet.user_name,
			slack: Faker::Internet.user_name,
			landline: Faker::Internet.user_name,
			mobile: Faker::Internet.user_name
		}
	)
end
