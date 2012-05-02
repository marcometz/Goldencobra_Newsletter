module GoldencobraNewsletter
  class NewsletterMailer < ActionMailer::Base

    default from: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.from") 
    default subject: Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject") 
    default :content_type => "text/html"
    default :reply_to => Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.reply_to") 

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.event_registration_mailer.registration.subject
    #
        
    def email_with_template(newsletter, email_template)
      GoldencobraNewsletter::NewsletterRegistration::LiquidParser["user"] = newsletter.user
      @email_template = email_template
      subject = @email_template.subject.present? ? @email_template.subject : Goldencobra::Setting.for_key("goldencobra_events.event.registration.mailer.subject") 
      @user = newsletter.user
      if @user && @user.present?
          mail to: @user.email, bcc: "#{@email_template.bcc}", :css => "/goldencobra_events/email", :subject => subject
      end
    end



  end
end
