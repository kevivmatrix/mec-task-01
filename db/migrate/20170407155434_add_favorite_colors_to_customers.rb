class AddFavoriteColorsToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :favorite_colors, :text, array: true, default: []
  end
end
