ActiveAdmin.register Customer do
	index download_links: [:csv] do
    # panel "Foo", :id => "index_header" do
    #   render :partial => "foo"
    #   text_node "Test"
    # end
    columns id: "index_header" do
      column span: 6 do
        span "#{customers.total_count} matching Customers"
      end
      column span: 6, class: "column text-right" do
        content_tag(:span) do
          "Download: #{link_to('CSV', admin_customers_path(format: "csv"))}".html_safe
        end
      end
    end
    # status_tag 'In Progress'
    column :code
    column :name
    column :email
    column :phone
    column :city
    column :country
    column :favorite_colors do |customer|
      customer.favorite_colors.join(", ")
    end
    tag_column :gender
    actions
  end

  filter :gender
  filter :name, filters: [ :contains ]
  # filter :favorite_colors, as: :select, collection: Customer::VALID_COLORS # Doesn't work
  # Works if multiple: true is set else returns empty array
  filter :single_favorite_color, as: :select, collection: Customer::VALID_COLORS, multiple: true
  filter :multiple_favorite_colors, label: "Select Multiple Favorite Colors", 
          as: :check_boxes, collection: Customer::VALID_COLORS, multiple: true

  permit_params :name, :email, :phone, :gender, 
                :address, :city, :country, :zip_code,
                :age, favorite_colors: []
end
