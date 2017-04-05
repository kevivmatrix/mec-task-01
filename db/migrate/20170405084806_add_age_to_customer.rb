class AddAgeToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :age, :integer
  end
end
