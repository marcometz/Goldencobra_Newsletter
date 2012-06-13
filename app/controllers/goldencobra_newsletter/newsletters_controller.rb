module GoldencobraNewsletter
  class NewslettersController < ApplicationController
    protect_from_forgery :except => [:register]

    #################################################################
    # Register method is called from registration form on website frontend.
    # If @user.create is successfull, a double-opt-in email is send.
    # User has to click link inside email to confirm her registration
    # Only then a newsletter.template_tag will be saved for the user.
    # Without a newsletter_tag the user cannot receive this newsletter.
    #################################################################
    
    def register
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
        newsletter_registration.send_double_opt_in(@user.email, params[:newsletter_tags])
      end
      respond_to do |format|
        format.js
      end
     end

    #################################################################
    # Find a NewsletterRegistration by email and delete the given
    # template_tag from the array of template_tags
    #################################################################

    def unsubscribe
      if params[:token]
        @user = User.find_by_authentication_token(params[:token])
        newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', @user.id).first if @user
      end
      @article = Goldencobra::Article.find_by_title("newsletter-site")
      if newsletter_registration && @user && newsletter_registration.newsletter_tags.include?(params[:tag])
        newsletter_registration.unsubscribe!(@user.email, params[:tag])
        render 'unsubscribe', layout: "application"
      else
        render 'no_registration_found', layout: "application"
      end
    end

    #################################################################
    # Find a NewsletterRegistration by authentication_token and
    # save a given template_tag in the NewsletterRegistrations
    # array of newsletter template_tags
    #################################################################

    def subscribe
      if params[:token]
        @user = User.find_by_authentication_token(params[:token])
        newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', @user.id).first
      end
      if newsletter_registration && @user
        @article = Goldencobra::Article.find_by_title("newsletter-site")
        newsletter_registration.subscribe!(@user.email, params[:tag])
        render 'subscribe', layout: "application"
      else
        redirect_to 'goldencobra/articles#show'
      end
    end

  end
end
