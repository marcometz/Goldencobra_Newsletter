module GoldencobraNewsletter
  class NewslettersController < ApplicationController

    def register

      if(check_for_valid_params(params))

        # wenn keien fehler: formular aus dom entfernen und danke hinschreiben
        # in session als newsletter-abonentn markieren, so dass formular nicht nochmal angezegit wird

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



    private

    def check_for_valid_params(params)

      return false if( ! params[:lastname].present? || params[:lastname] == "")

      return false if( ! params[:company].present? || params[:company] == "")

      return false if( ! params[:firstname].present? || params[:firstname] == "")


      return true

    end

  end
end
