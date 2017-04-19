ActiveAdmin.register BasicCustomerReport do
	menu parent: "Report"

	actions :index, :generate

	index do
		column :file do |basic_customer_report|
			basic_customer_report.file || "Generating..."
		end
		column :parameters
		tag_column :status
	end

	filter :created_at

	collection_action :generate, method: :get do
  	BasicCustomerReport.create.generate
    redirect_to collection_path, notice: "Report Generation in progress"
  end

  action_item only: :index do
	  link_to 'Generate Report', generate_admin_basic_customer_reports_url
	end
end
