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
    column :customer_type
    column :name
    column :email
    column :phone
    column :city
    column :country
    column :favorite_colors do |customer|
      customer.favorite_colors.join(", ")
    end
    tag_column :gender
    column :age
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
      f.input :customer_type
      f.input :name
      f.input :email
      f.input :phone
      f.input :gender
      f.input :address
      f.input :city
      f.input :country
      f.input :zip_code
      f.input :age
      f.input :favorite_colors, as: :select
    end
    f.inputs "Contacts" do
      f.input :facebook, input_html: { name: "customer[contacts][facebook]" }
      f.input :twitter, input_html: { name: "customer[contacts][twitter]" }
      f.input :instagram, input_html: { name: "customer[contacts][instagram]" }
      f.input :pinterest , input_html: { name: "customer[contacts][pinterest]" }
      f.input :linkedin, input_html: { name: "customer[contacts][linkedin]" }
      f.input :reddit, input_html: { name: "customer[contacts][reddit]" }
      f.input :google_plus, input_html: { name: "customer[contacts][google_plus]" }
      f.input :skype, input_html: { name: "customer[contacts][skype]" }
      f.input :slack, input_html: { name: "customer[contacts][slack]" }
      f.input :landline, input_html: { name: "customer[contacts][landline]" }
      f.input :mobile, input_html: { name: "customer[contacts][mobile]" }
    end
    f.actions
  end

  filter :gender
  filter :city
  filter :customer_type
  filter :name, filters: [ :contains ]
  filter :has_one_of_these_colors, collection: Customer::VALID_COLORS, as: :select
  filter :has_any_of_these_colors, as: :check_boxes, 
          collection: Customer::VALID_COLORS, multiple: true
  filter :has_all_of_these_contact_types, collection: Customer::CONTACT_TYPES,
          as: :select, multiple: true
  filter :has_contact_which_contains

  action_item :generate_report, only: :index do
    link_to(
      'Generate Report', 
      new_admin_report_url(
        parameters: {
          q: params[:q].try(:to_unsafe_h),
          order: params[:order]
        }
      )
    )
  end

  permit_params :customer_type_id, :name, :email, :phone, :gender, 
                :address, :city_id, :country, :zip_code,
                :age, contacts: Customer::CONTACT_TYPES, favorite_colors: []

  controller do

    def create
      prevent_empty_contact_types!
      create!{ collection_path }
    end

    def update
      prevent_empty_contact_types!
      update!{ collection_path }
    end

    private

    def prevent_empty_contact_types!
      # To avoid empty strings in contact types
      Customer::CONTACT_TYPES.each do |contact_type|
        if params["customer"]["contacts"][contact_type].empty?
          params["customer"]["contacts"].delete contact_type
        end
      end
    end

  end
end
