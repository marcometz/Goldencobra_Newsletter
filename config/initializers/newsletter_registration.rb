Rails.application.config.to_prepare do
  require "devise"
  User.class_eval do

    belongs_to :newsletter_registration, :class_name => GoldencobraNewsletter::NewsletterRegistration

  end
end
