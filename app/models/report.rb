class Report < ApplicationRecord
	extend Enumerize

	attr_accessor :core_data

	mount_uploader :file, FileUploader
	
	VALID_STATUSES = %w{ waiting processing completed failed }

	enumerize :status, in: VALID_STATUSES, default: "waiting", predicates: true

	validates_uniqueness_of :label, case_sensitive: false, allow_blank: true
	validates_presence_of :type

	after_create do
		ReportJob.perform_later(self)
	end

	def self.batch_size
		250
	end

	def self.allows_ransack_params
    true
  end

	def generate format="csv"
		data = send("generate_#{format}")
		File.open(temp_report_file_path(format), 'w') do |temp_file|
			temp_file.write(data)
			self.file = temp_file
			self.save
		end
	end

	def generate_csv
		set_core_data
		apply_filters
		apply_sorting
		CSV.generate do |csv|
			csv << header
			data_for_csv csv
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

		def temp_report_file_path format
      Rails.root.join("tmp", temp_report_file_name(format))
    end

    def formatted_data_batch &block
			ids = core_data.result.ids
			ids.each_slice(self.class.batch_size) do |chunk|
				yield chunk
			end
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

    def set_core_data
    	@core_data = self.class.core_scope
    end

    def apply_filters
    	if self.class.allows_ransack_params
	      @core_data = self.class.core_scope.ransack(parameters["q"])
    	end
    end

    def apply_sorting
			if parameters["order"].present?
			  @core_data.sorts = parameters["order"].gsub(/(.*)\_(desc|asc)/, '\1 \2')
			end
    end

end
