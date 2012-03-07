module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register


      user = User.find_by_email(params[:email])

      old_newsletter = user.newsletter || false

      user.newsletter = true

      user.save!

      render :text => "user.lastname " + user.lastname + "; old_newsletter: " + old_newsletter.to_s

    end

  end
end
