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
    column :contacts do |customer|
      Customer::CONTACT_TYPES.map do |contact_type|
        contact_type_value = customer.send(contact_type)
        "#{contact_type_value} (#{contact_type})" if contact_type_value.present?
      end.compact.join(", ")
    end
    actions
  end

  form do |f|
    f.inputs "Basic Info" do
      f.input :name
      f.input :email
      f.input :phone
      f.input :gender
      f.input :address
      f.input :city
      f.input :country
      f.input :zip_code
      f.input :age
    end
    f.inputs "Contacts" do
      f.input :facebook
      f.input :twitter
      f.input :instagram
      f.input :pinterest 
      f.input :linkedin
      f.input :reddit
      f.input :google_plus
      f.input :skype
      f.input :slack
      f.input :email
      f.input :landline
      f.input :mobile
    end
    f.actions
  end

  filter :gender
  filter :name, filters: [ :contains ]
  filter :has_one_of_these_colors, collection: Customer::VALID_COLORS, as: :select
  filter :has_any_of_these_colors, as: :check_boxes, 
          collection: Customer::VALID_COLORS, multiple: true
  filter :has_all_of_these_contact_types, collection: Customer::CONTACT_TYPES,
          as: :select, multiple: true
  filter :has_contact_which_contains

  permit_params :name, :email, :phone, :gender, 
                :address, :city, :country, :zip_code,
                :age, :facebook, :twitter, :instagram, 
                :pinterest, :linkedin, :reddit, :google_plus, 
                :skype, :slack, :email, :landline, :mobile,
                favorite_colors: []
end
