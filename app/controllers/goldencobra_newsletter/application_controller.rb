module GoldencobraNewsletter
  class ApplicationController < ActionController::Base
    
    before_filter :get_newsletter_form
    
    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
    
    def get_newsletter_form
      Goldencobra::Article::LiquidParser["newsletter_formular"] = render(:partial => "goldencobra_newsletter/newsletters/register")
    end
    
  end
end
