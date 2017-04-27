ActiveAdmin.register CustomerColorReport do
	menu parent: "Report"

	actions :index, :generate

	index do
		column :file do |customer_color_report|
			if customer_color_report.completed?
				link_to "Customer Color Report ##{customer_color_report.id}", customer_color_report.file.url
			else
				"Generating..."
			end
		end
		column :parameters
		tag_column :status
	end

	filter :created_at

	collection_action :generate, method: :get do
		CustomerColorReportJob.perform_later(
			q: params[:q].try(:to_unsafe_h),
      order: params[:order]
		)
    redirect_to collection_path, notice: "Customer Color Report Generation in progress"
  end

  action_item :generate_report, only: :index do
	  link_to 'Generate Report', generate_admin_customer_color_reports_url
	end
end
