ActiveAdmin.register User, :as => "Master Data" do
  controller.authorize_resource :class => User

  scope :event_registration_present
  scope :event_registration_not_present
  scope :event_and_newsletter_registration_present

  filter :firstname
  filter :lastname
  filter :email
  filter :company_name

  index do
    selectable_column
    column :firstname, sortable: true
    column :lastname, sortable: true
    column :email, sortable: true
    column :newsletter_registration, sortable: true do |user|
      link_to "Newsletter Anmeldung bearbeiten", edit_admin_newsletter_registration_path(GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).first) if GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).any?
    end
    if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
      column :event_registration, sortable: true do |user|
        link_to "Event Anmeldungen", "/admin/applicants?q%5Bemail_contains%5D=#{user.email}&commit=Filtern&order=id_desc&scope=" if GoldencobraEvents::RegistrationUser.where(user_id: user.id).any?
      end
    end
    default_actions
  end

end