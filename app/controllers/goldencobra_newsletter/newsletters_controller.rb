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
        @user = User.create(:firstname => params[:first_name],
                            :lastname => params[:last_name],
                            :email => params[:email],
                            :password => generated_pass,
                            :password_confirmation => generated_pass,
                            gender: params[:gender])
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
      if @success
        newsletter_registration.subscribe!(@user.email, params[:newsletter_tags])
      end
      respond_to do |format|
        format.js
      end
     end

    def unsubscribe
      @user = User.find_by_email(params[:email])
      newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', @user.id).first
      if newsletter_registration && @user
        tags = []
        tags << newsletter_registration.newsletter_tags
        tags.delete(params[:tag])
        newsletter_registration.update_attributes(newsletter_tags: tags.compact.join(","))
        @template = GoldencobraEmailTemplates::EmailTemplate.find_by_template_tag(params[:tag])
        GoldencobraNewsletter::NewsletterMailer.confirm_cancel_subscription(@user, @template).deliver
      end
      render nothing: true
    end

    def subscribe
      @user = User.find_by_email(params[:email])
      newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', @user.id).first
      if newsletter_registration && @user
        newsletter_registration.subscribe!(params[:email], params[:tag])
      end
      render nothing: true
    end

  end
end
