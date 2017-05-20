ActiveAdmin.register Report do 

	index do
		column :file do |report|
			content_tag :div, data: { job_id: report.background_job_id, status: report.status }, class: "report_data_cell" do
				if report.completed?
					link_to report.file_name, report.file.url
				else
					"Generating..."
				end
			end
		end
		column :type
		column :parameters do |report|
			translated_parameters = report.translate_ransack_parameters
			if translated_parameters.present?
				translated_parameters.gsub("\n", "<br/>").html_safe
			else
				"None"
			end
		end
		column :status do |report|
			content_tag :div, class: "report_progress_cell" do
				content_tag(:span, report.status, class: "status_tag #{report.status}") do
					if report.completed? || report.failed?
						report.status
					else
						"#{report.status} 0%"
					end
				end
			end
		end
		column :status_description
		actions
	end

	form do |f|
		f.inputs do
			f.input :label
			if params[:parameters].present?
				f.input :type, as: :select, collection: %w{ BasicCustomerReport CustomerContactAgeReport }
			else
				f.input :type, as: :select, collection: %w{ BasicCustomerReport CustomerColorReport CustomerContactAgeReport }
			end
			f.input :parameters, as: :text
		end
		f.actions
	end

	filter :created_at

	permit_params :label, :type, parameters: {}

	controller do

		def new
			super do
	      resource.type = params[:type] if params[:type]
	      if params[:parameters]
					resource.parameters = params[:parameters].try(:to_unsafe_h).to_json
				end
	    end
    end

    def create
    	params[:report][:parameters] = JSON.parse params[:report][:parameters]
      create!{ collection_path }
    end

	end

end
