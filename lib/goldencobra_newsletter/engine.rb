
module GoldencobraNewsletter
  class Engine < ::Rails::Engine
    isolate_namespace GoldencobraNewsletter

    config.to_prepare do
      ApplicationController.helper(GoldencobraNewsletter::ApplicationHelper)
      ActionController::Base.helper(GoldencobraNewsletter::ApplicationHelper)

      ApplicationController.helper(GoldencobraNewsletter::NewslettersHelper)
      ActionController::Base.helper(GoldencobraNewsletter::NewslettersHelper)
    end

  end
end
