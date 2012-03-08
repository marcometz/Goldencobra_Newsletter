module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      # wenn keien fehler: formular aus dom entfernen und danke hinschreiben
      # in session als newsletter-abonentn markieren, so dass formular nicht nochmal angezegit wird

      @success = false

      @user = User.find_by_email(params[:email])

      if @user.blank?
        generated_pass = NewsletterRegistration.generate_random_dummy_password()
        @user = User.create(:firstname => params[:first_name], :lastname => params[:last_name], :email => params[:email], :password => generated_pass, :password_confirmation => generated_pass)
      end

      if @user
        if @user.newsletter_registration.blank?
          @user.newsletter_registration = NewsletterRegistration.new
        end

        @user.newsletter_registration.company_name = params[:company]
        @user.newsletter_registration.is_subscriber = true

        @success = @user.save

      end

    end

  end
end
