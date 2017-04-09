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
    tag_column :gender
    actions
  end
  filter :gender
  filter :name, filters: [ :contains ]
  # filter :favorite_colors,
  #    collection: -> { Customer.all }

  filter :name_cont

  permit_params :name, :email, :phone, :gender, 
                :address, :city, :country, :zip_code
end
