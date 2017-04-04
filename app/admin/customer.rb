ActiveAdmin.register Customer do
	index download_links: [:csv] do
    column :code
    column :name
    column :email
    column :gender
    column :phone
    column :city
    column :country
	end
end
