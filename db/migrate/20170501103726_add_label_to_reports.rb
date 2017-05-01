class AddLabelToReports < ActiveRecord::Migration[5.1]
  def change
    add_column :reports, :label, :string, unique: true
  end
end
