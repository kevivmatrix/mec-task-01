ActiveAdmin.register CustomerContactAgeReport do
	menu parent: "Report"

	actions :index, :generate

	index do
		column :file do |customer_contact_age_report|
			if customer_contact_age_report.completed?
				link_to "Customer Contact-Age Report ##{customer_contact_age_report.id}", customer_contact_age_report.file.url
			else
				"Generating..."
			end
		end
		column :parameters
		tag_column :status
		column :status_description
	end

	filter :created_at

	collection_action :generate, method: :get do
		CustomerContactAgeReportJob.perform_later(
			q: params[:q].try(:to_unsafe_h),
      order: params[:order]
		)
    redirect_to collection_path, notice: "Customer Contact Age Report Generation in progress"
  end

  action_item :generate_report, only: :index do
	  link_to 'Generate Report', generate_admin_customer_contact_age_reports_url
	end
end
