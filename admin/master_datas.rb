ActiveAdmin.register User, :as => "Master Data" do
  controller.authorize_resource :class => User

  scope :event_registration_present
  scope :event_registration_not_present
  scope :event_and_newsletter_registration_present

  filter :firstname
  filter :lastname
  filter :email
  filter :company_name, as: :string

  index do
    selectable_column
    column :firstname, sortable: true
    column :lastname, sortable: true
    column :email, sortable: true
    if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
      column "Anmeldungen" do |user|
        count = GoldencobraEvents::RegistrationUser.where(user_id: user.id).count
        if count > 0
          link_to "Liste von Event-Anmeldungen (#{count})", "/admin/applicants?q%5Bemail_contains%5D=#{user.email}&commit=Filtern&order=id_desc&scope="
        end
      end
    end
    column "" do |user|
      if GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).any?
        link_to "Bearbeiten", edit_admin_newsletter_registration_path(GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).first)
      else
        link_to "Bearbeiten", edit_admin_master_datum_path(user.id)
      end
    end
  end

 form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "Allgemein", class: "foldable inputs" do
      f.input :gender, as: :select, include_blank: false, collection: [["Herr", true],["Frau", false]]
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :function
      f.input :phone
      f.input :fax
      f.input :facebook
      f.input :twitter
      f.input :linkedin
      f.input :xing
      f.input :googleplus
    end
    # f.inputs "Newsletter" do
    #   f.fields_for :user_attributes, f.object.user do |u|
    #     u.inputs "" do
    #       f.input :company_name
    #       f.input :is_subscriber
    #       f.input :newsletter_tags
    #     end
    #   end
    # end
    # f.inputs "Adresse" do
    #   f.fields_for :location_attributes, f.object.location do |l|
    #     l.inputs "" do
    #       l.input :street
    #       l.input :zip
    #       l.input :city
    #       l.input :country, as: :string
    #     end
    #   end
    # end
    f.actions
  end
end