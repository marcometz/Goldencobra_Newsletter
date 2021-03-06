Rails.application.config.to_prepare do
  User.class_eval do


    def company_name
      if self.newsletter_registration
        self.newsletter_registration.company_name
      elsif defined?(GoldencobraEvents)
        reguser = GoldencobraEvents::RegistrationUser.where(user_id: self.id).last
        if reguser && reguser.company
          reguser.company.title
        else
          ""
        end
      else
        ""
      end
    end

    def location
      if self.newsletter_registration && self.newsletter_registration.location
        self.newsletter_registration.location
      elsif defined?(GoldencobraEvents)
        reguser = GoldencobraEvents::RegistrationUser.where(user_id: self.id).last
        if reguser && reguser.company && reguser.company.location
          reguser.company.location
        else
          Goldencobra::Location.new
        end
      else
        Goldencobra::Location.new
      end
    end

  end
end