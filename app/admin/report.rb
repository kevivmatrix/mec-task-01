ActiveAdmin.register Report do

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
			f.input :type, as: :select, collection: %w{ BasicCustomerReport CustomerColorReport CustomerContactAgeReport }
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
