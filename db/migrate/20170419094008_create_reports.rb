class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :file
      t.string :type
      t.text :parameters, array: true, default: []

      t.timestamps
    end
  end
end
