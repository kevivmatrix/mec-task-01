ActiveAdmin.register BasicCustomerReport do
	menu parent: "Report"

	actions :index, :generate

	index do
		column :file do |basic_customer_report|
			if basic_customer_report.completed?
				link_to "Report ##{basic_customer_report.id}", basic_customer_report.file.url
			else
				"Generating..."
			end
		end
		column :parameters
		tag_column :status
	end

	filter :created_at

	collection_action :generate, method: :get do
		BasicCustomerReportJob.perform_later(
			q: params[:q].try(:to_unsafe_h),
      order: params[:order]
		)
    redirect_to collection_path, notice: "Basic Customer Report Generation in progress"
  end

  action_item :generate_report, only: :index do
	  link_to 'Generate Report', generate_admin_basic_customer_reports_url
	end
end
