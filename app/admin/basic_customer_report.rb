ActiveAdmin.register BasicCustomerReport do
	menu parent: "Report"

	actions :index, :generate

	index do
		column :file do |basic_customer_report|
			if basic_customer_report.completed?
				link_to "Basic Customer Report ##{basic_customer_report.id}", basic_customer_report.file.url
			else
				"Generating..."
			end
		end
		column :parameters do |basic_customer_report|
			basic_customer_report.translate_ransack_parameters.
				gsub("\n", "<br/>").html_safe
		end
		tag_column :status
		column :status_description
	end

	filter :created_at

	collection_action :generate, method: :get do
		basic_customer_report = BasicCustomerReport.create(
			parameters: {
				q: params[:q].try(:to_unsafe_h),
      	order: params[:order]
			}
		)
		ReportJob.perform_later(basic_customer_report)
    redirect_to collection_path, notice: "Basic Customer Report Generation in progress"
  end

  action_item :generate_report, only: :index do
	  link_to 'Generate Report', generate_admin_basic_customer_reports_url
	end
end
