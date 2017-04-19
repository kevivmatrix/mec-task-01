class CreateReports < ActiveRecord::Migration[5.1]
  def change
    create_table :reports do |t|
      t.string :file
      t.string :type
      t.jsonb :parameters, null: false, default: '{}'
  		t.index :parameters, using: :gin

      t.timestamps
    end
  end
end
