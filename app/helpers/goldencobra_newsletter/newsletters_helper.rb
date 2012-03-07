module GoldencobraNewsletter
  module NewslettersHelper
    def newsletter_registration_form
      # render :text => "HIER KOMMT DAS TOLLE FORM REIN"

      # return_content += content_tag(:div, render(:partial => "goldencobra_events/events/user"), :style => "display:none", :id => "goldencobra_events_enter_account_data_form")

      render :partial => "goldencobra_newsletter/newsletters/register"
    end

    def helper_neu(field_name, options = {})

      css_prefix = "goldencobra-newsletter-registration"

      content_tag :div, :class => css_prefix do

        if options[:required]
          "DER NEUE HELPER: #{field_name} -- #{options}"
        end
      end

  # <div class="#{css_prefix}-field-group">
  #   <%= label_tag(:title, "Titel") %>
  #   <%= text_field_tag(:title, nil, :id => "#{css_prefix}-field-title") %>
  # </div>

    end

  end
end
