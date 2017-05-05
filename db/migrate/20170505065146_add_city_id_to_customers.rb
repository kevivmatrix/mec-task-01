class AddCityIdToCustomers < ActiveRecord::Migration[5.1]
  def change
    remove_column :customers, :city
    add_reference :customers, :city, foreign_key: true
  end
end
