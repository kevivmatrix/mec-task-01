# Customer Sample Data

100.times do
	Customer.create(
		name: 		Faker::Name.name,
		email: 		Faker::Internet.email,
		phone: 		Faker::PhoneNumber.phone_number,
		gender:   Faker::Boolean.boolean ? "male" : "female",
		address: 	"#{Faker::Address.secondary_address}, #{Faker::Address.street_name}, #{Faker::Address.street_address}",	
		city: 		Faker::Address.city,
		country: 	Faker::Address.country,
		zip_code: Faker::Address.zip_code,
		age:      Faker::Number.between(18, 99),
		favorite_colors: Customer::VALID_COLORS.sample(2)
	)
end
