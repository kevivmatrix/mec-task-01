class AddStatusDescriptionToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :status_description, :text
  end
end
