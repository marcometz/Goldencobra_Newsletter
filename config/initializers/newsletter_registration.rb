Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do

    has_one :newsletter_registration, :class_name => GoldencobraNewsletter::NewsletterRegistration

  end
end

