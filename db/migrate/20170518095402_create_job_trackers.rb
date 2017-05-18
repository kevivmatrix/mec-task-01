class CreateJobTrackers < ActiveRecord::Migration[5.1]
  def change
    create_table :job_trackers do |t|
      t.references :trackable, polymorphic: true
      t.string :status
      t.float :percent, default: 0

      t.timestamps
    end
  end
end
