module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      # wenn keien fehler: formular aus dom entfernen und danke hinschreiben
      # in session als newsletter-abonentn markieren, so dass formular nicht nochmal angezegit wird

      user = User.find_by_email(params[:email])

      if user == nil

        generated_pass = Digest::MD5.new.hexdigest("pass-#{Time.now.to_f}")
        user = User.create(:firstname => params[:firstname], :lastname => [:lastname], :email => params[:email], :password => generated_pass, :password_confirmation => generated_pass)

        user.save!

      end

      if user.newsletter_registration == nil
        user.newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.new
      end

      user.company_name = params[:company_name]
      user.is_subscriber = true

      user.save!


    end



  end
end
