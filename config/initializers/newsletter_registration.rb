Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do

    has_one :newsletter_registration, :class_name => GoldencobraNewsletter::NewsletterRegistration

    if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
      scope :event_registration_present, joins(:registration_users).where("goldencobra_events_registration_users.user_id IS NOT NULL")
      scope :event_registration_not_present, joins(:registration_users).where("goldencobra_events_registration_users.user_id IS NULL")

      scope :event_and_newsletter_registration_present, joins(:registration_users, :newsletter_registration).where("goldencobra_events_registration_users.user_id IS NOT NULL AND goldencobra_newsletter_newsletter_registrations.user_id IS NOT NULL")

      scope :event_registration_present_eq, lambda{ |text| joins(:registration_users).where("goldencobra_events_registration_users.user_id = #{text}") }
      search_methods :event_registration_present_eq
    end

    scope :company_name_eq, lambda { |search_term| joins(:registration_users).where("goldencobra_newsletter_newsletter_registrations.company_name LIKE '%#{search_term}%'") }
    search_methods :company_name_eq
    # scope :location_present, joins(:location).where("goldencobra_locations.street <> '' AND goldencobra_locations.zip <> ''")
    # scope :location_present_eq, lambda { |text| joins(:location).where("goldencobra_locations.street <> '' AND goldencobra_locations.zip <> ''") }
    # search_methods :location_present_eq

  end
end



