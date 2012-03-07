module GoldencobraNewsletter
  module NewslettersHelper
    def newsletter_registration_form
      # render :text => "HIER KOMMT DAS TOLLE FORM REIN"

      # return_content += content_tag(:div, render(:partial => "goldencobra_events/events/user"), :style => "display:none", :id => "goldencobra_events_enter_account_data_form")

      render :partial => "goldencobra_newsletter/newsletters/register"


    end

  end
end
