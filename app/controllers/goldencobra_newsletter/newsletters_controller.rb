module GoldencobraNewsletter
  class NewslettersController < ApplicationController
    protect_from_forgery :except => [:register]

    def register

      # wenn keien fehler: formular aus dom entfernen und danke hinschreiben
      # in session als newsletter-abonentn markieren, so dass formular nicht nochmal angezegit wird

      @success = false
      @user = User.find_by_email(params[:email])

      if @user.blank?
        generated_pass = NewsletterRegistration.generate_random_dummy_password()
        @user = User.create(:firstname => params[:first_name], :lastname => params[:last_name], :email => params[:email], :password => generated_pass, :password_confirmation => generated_pass)
      end

      if @user.present?
        newsletter_registration = @user.newsletter_registration

        if newsletter_registration.blank?
          newsletter_registration = NewsletterRegistration.new
        end
        if params[:company] && params[:company].length > 0
          newsletter_registration.company_name = params[:company]
        else
          newsletter_registration.company_name = "privat"
        end
        newsletter_registration.is_subscriber = true

        @user.newsletter_registration = newsletter_registration
        @success = @user.save

      end
    end

  end
end
