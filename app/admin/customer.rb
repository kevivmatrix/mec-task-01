ActiveAdmin.register Customer do
	index do
		column :name
		column :email
		column :gender
		column :phone
		column :city
		column :country
	end
end
