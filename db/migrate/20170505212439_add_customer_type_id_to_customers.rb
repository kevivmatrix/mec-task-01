class AddCustomerTypeIdToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_reference :customers, :customer_type, foreign_key: true
  end
end
