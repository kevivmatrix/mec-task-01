class Report < ApplicationRecord
	extend Enumerize

	mount_uploader :file, FileUploader
	
	VALID_STATUSES = %w{ waiting processing completed failed }

	enumerize :status, in: VALID_STATUSES, default: "waiting", predicates: true

	def generate format="csv"
		data = send("data_for_#{format}")
		File.open(temp_report_file_path(format), 'w') do |temp_file|
			temp_file.write(data)
			self.file = temp_file
			self.save
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

	private

		def temp_report_file_path format
			Rails.root.join("tmp", "report_#{self.id}.#{format}")
		end
end
