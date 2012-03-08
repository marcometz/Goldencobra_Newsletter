module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      user = User.find_by_email(params[:email])

      if user
        user.newsletter = true

        user.save!

      else

        generated_pass = Digest::MD5.new.hexdigest("pass-#{Time.now.to_f}")

        user = User.create(:firstname => params[:firstname], :lastname => [:lastname], :email => params[:email], :password => generated_pass, :password_confirmation => generated_pass)


      end
    end

  end
end
