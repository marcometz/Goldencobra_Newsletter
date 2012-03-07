module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      user = User.find_by_email(params[:email])

      if user
        user.newsletter = true

        user.save!

      else

        user = User.create(:firstname => "daniel", :lastname => "Spaude", :email => "daniel@spaude.de", :password => "pass12345", :password_confirmation => "pass12345")


      end

      # render :text => "user.lastname " + user.lastname + "; old_newsletter: " + old_newsletter.to_s

    end

  end
end
