ActiveAdmin.register BasicCustomerReport do
	menu parent: "Report"

	actions :index

	index do
		field :file
		field :parameters
		tag_column :status
	end

	filter :created_at
end
