module GoldencobraNewsletter
  module NewslettersHelper
    def newsletter_registration_form
      # render :text => "HIER KOMMT DAS TOLLE FORM REIN"

      # return_content += content_tag(:div, render(:partial => "goldencobra_events/events/user"), :style => "display:none", :id => "goldencobra_events_enter_account_data_form")

      render :partial => "goldencobra_newsletter/newsletters/register"
    end

    def helper_neu(field_name, options = {})

      css_prefix = "goldencobra-newsletter-registration"

      content_tag :div, :class => "#{css_prefix}-field-group" do
        text_field_id = css_prefix + "-field-" + field_name.to_s.gsub('-','_')

        return label_tag(field_name, field_name) +
        text_field_tag(field_name, nil, :id => text_field_id, :required => options[:required])

      end

    end

  end
end
