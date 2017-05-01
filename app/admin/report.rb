ActiveAdmin.register Report do
	menu parent: "Report"

	# actions :index, :generate

	index do
		column :file do |customer_contact_age_report|
			if customer_contact_age_report.completed?
				link_to "Customer Contact-Age Report ##{customer_contact_age_report.id}", customer_contact_age_report.file.url
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

	form do |f|
		f.inputs do
			f.input :label
			f.input :parameters, as: :text
		end
		f.actions
	end

	filter :created_at

	# collection_action :generate, method: :get do
	# 	customer_contact_age_report = CustomerContactAgeReport.create(
	# 		parameters: {
	# 			q: params[:q].try(:to_unsafe_h),
 #      	order: params[:order]
	# 		}
	# 	)
	# 	ReportJob.perform_later(customer_contact_age_report)
 #    redirect_to collection_path, notice: "Customer Contact Age Report Generation in progress"
 #  end

 	# action_item :generate_report, only: :index do
	#   link_to 'Generate Report', generate_admin_customer_contact_age_reports_url
	# end
end
