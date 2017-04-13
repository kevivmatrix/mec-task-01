class AddContactsToCustomer < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :contacts, :jsonb, null: false, default: '{}'
    add_index  :customers, :contacts, using: :gin
  end
end
