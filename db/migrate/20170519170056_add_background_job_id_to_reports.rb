class AddBackgroundJobIdToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :background_job_id, :string
  end
end
