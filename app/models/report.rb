class Report < ApplicationRecord
	extend Enumerize

	attr_accessor :core_data, :filters, :sort, :background_job

	mount_uploader :file, FileUploader
	
	VALID_STATUSES = %w{ waiting processing completed failed }

	enumerize :status, in: VALID_STATUSES, default: "waiting", predicates: true

	validates_uniqueness_of :label, case_sensitive: false, allow_blank: true
	validates_presence_of :type

	after_create do
		# ReportJob.perform_later(self.id)
		job_id = ReportJob.perform_async(self.id)
    self.update background_job_id: job_id
	end

	def self.batch_size
		250
	end

	def self.allows_ransack_params
    true
  end

	def generate options={format: "csv"}
		format = options[:format] || "csv"
		@background_job = options[:background_job]
  	@filters = parameters["q"]
    @sort = parameters["order"]
  	set_core_data
		apply_filters
		apply_sorting
		data = send("generate_#{format}")
		File.open(temp_report_file_path(format), 'w') do |temp_file|
			temp_file.write(data)
			self.file = temp_file
			self.save
		end
	end

	def generate_csv
		CSV.generate do |csv|
			csv << header
			data_for_csv(csv)
		end
	end

	def waiting! description="Waiting"
		update status: "waiting", status_description: description
	end

	def processing! description="Processing"
		update status: "processing", status_description: description
	end

	def completed! description="Completed"
		update status: "completed", status_description: description
	end

	def failed! description="Failed"
		update status: "failed", status_description: description
	end

	def translate_ransack_parameters
		translation = []
		if parameters["q"].present?
			parameters["q"].each do |key, value|
				value = value.is_a?(Array) ? value.join(", ") : value
				if value.present?
					translation << "#{key.humanize} - #{value}"
				end
			end
		end
		if parameters["order"].present?
			translation << "Order - #{parameters["order"].humanize}"
		end
		translation.join("\n")
	end

	def file_name
		File.basename file.url.split("?")[0]
	end

	private

		def header
      self.class.csv_columns.values
    end

		def temp_report_file_path format
      Rails.root.join("tmp", temp_report_file_name(format))
    end

    def temp_report_file_name format
    	file_name = if label.present?
    		label.downcase.gsub(" ", "_")
    	elsif type.present?
    		"#{type.underscore}_#{id}"
    	else
    		"report_#{id}"
    	end
    	"#{file_name}.#{format}"
    end

    def empty_row csv
    	csv << []
    end

    def add_row csv, *values
    	csv << values
    end

    def set_core_data
    	@core_data = self.class.core_scope
    end

    def core_data_count
    	@core_data_count ||= core_data.result.count
    end

    def apply_filters
    	if self.class.allows_ransack_params
	      @core_data = @core_data.ransack(filters)
    	end
    end

    def apply_sorting
			if sort.present?
			  @core_data.sorts = sort.gsub(/(.*)\_(desc|asc)/, '\1 \2')
			end
    end

    def track_background_job percent
	  	if background_job
	  		background_job.at percent
	  	end
	  end

end
