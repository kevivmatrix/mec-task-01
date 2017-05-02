ActiveAdmin.register Report do

	ALL_REPORTS = %w{ BasicCustomerReport CustomerColorReport CustomerContactAgeReport }
	CUSTOMER_FILTERABLE_REPORTS = %w{ BasicCustomerReport CustomerContactAgeReport }

	index do
		column :file do |report|
			if report.completed?
				link_to report.file_name, report.file.url
			else
				"Generating..."
			end
		end
		column :parameters do |report|
			report.translate_ransack_parameters.
				gsub("\n", "<br/>").html_safe
		end
		tag_column :status
		column :status_description
		actions
	end

	form do |f|
		f.inputs do
			f.input :label
			if params[:parameters].present?
				f.input :type, as: :select, collection: CUSTOMER_FILTERABLE_REPORTS
			else
				f.input :type, as: :select, collection: ALL_REPORTS
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
