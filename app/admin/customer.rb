ActiveAdmin.register Customer do
	index download_links: [:csv] do
    # panel "Foo", :id => "index_header" do
    #   render :partial => "foo"
    #   text_node "Test"
    # end
    columns id: "index_header" do
      column span: 12 do
        span "#{customers.total_count} matching Customers"
      end
    end
    # status_tag 'In Progress'
    column :code
    column :name
    column :email
    column :gender
    column :phone
    column :city
    column :country
    actions
  end
  # filter :name, filters: [ :contains ]
end
