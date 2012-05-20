
module GoldencobraNewsletter
  class Engine < ::Rails::Engine
    isolate_namespace GoldencobraNewsletter

    config.to_prepare do
      ApplicationController.helper(GoldencobraNewsletter::ApplicationHelper)
      ActionController::Base.helper(GoldencobraNewsletter::ApplicationHelper)
      DeviseController.helper(GoldencobraNewsletter::ApplicationHelper)           

      ApplicationController.helper(GoldencobraNewsletter::NewslettersHelper)
      ActionController::Base.helper(GoldencobraNewsletter::NewslettersHelper)
      DeviseController.helper(GoldencobraNewsletter::NewslettersHelper)       
      
      Devise::SessionsController.helper(GoldencobraNewsletter::ApplicationHelper)            
      Devise::SessionsController.helper(GoldencobraNewsletter::NewslettersHelper)            
    end

  end
end
