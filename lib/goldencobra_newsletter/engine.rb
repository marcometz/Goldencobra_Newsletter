
module GoldencobraNewsletter
  class Engine < ::Rails::Engine
    isolate_namespace GoldencobraNewsletter

    config.to_prepare do
      ApplicationController.helper(GoldencobraNewsletter::ApplicationHelper)
      ActionController::Base.helper(GoldencobraNewsletter::ApplicationHelper)
      DeviseController.helper(Goldencobra::ApplicationHelper)           

      ApplicationController.helper(GoldencobraNewsletter::NewslettersHelper)
      ActionController::Base.helper(GoldencobraNewsletter::NewslettersHelper)
      DeviseController.helper(Goldencobra::NewslettersHelper)           
    end

  end
end
