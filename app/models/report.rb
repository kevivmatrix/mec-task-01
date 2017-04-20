class Report < ApplicationRecord
	extend Enumerize

	mount_uploader :file, FileUploader
	
	VALID_STATUSES = %w{ pending processing complete }

	enumerize :status, in: VALID_STATUSES, default: "pending", predicates: true

	def generate format="csv"
		self.processing!
		data = send("data_for_#{format}")
		File.open(temp_report_file_path(format), 'w') do |temp_file|
			temp_file.write(data)
			self.file = temp_file
			self.save
		end
		self.completed!
	end

	def pending!
		update status: "pending"
	end

	def processing!
		update status: "processing"
	end

	def completed!
		update status: "complete"
	end

	private

		def temp_report_file_path format
			Rails.root.join("tmp", "reports_#{self.id}.#{format}")
		end
end
