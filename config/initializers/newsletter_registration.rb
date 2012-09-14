Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do

    has_one :newsletter_registration, :class_name => GoldencobraNewsletter::NewsletterRegistration

    if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
      # scope :event_registration_present, joins(:registration_user).where("goldencobra_events_registration_users.user_id = ?", self.id)
      scope :event_registration_present_eq, lambda{ |text| joins(:registration_user).where("goldencobra_events_registration_users.user_id = #{text}") }
      search_methods :event_registration_present_eq
    end

    # scope :location_present, joins(:location).where("goldencobra_locations.street <> '' AND goldencobra_locations.zip <> ''")
    # scope :location_present_eq, lambda { |text| joins(:location).where("goldencobra_locations.street <> '' AND goldencobra_locations.zip <> ''") }
    # search_methods :location_present_eq

  end
end



