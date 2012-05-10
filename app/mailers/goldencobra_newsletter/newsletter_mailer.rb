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
      do_not_deliver! unless newsletter.is_subscriber
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

# http://stackoverflow.com/questions/6550809/rails-3-how-to-abort-delivery-method-in-actionmailer

module ActionMailer
  class Base
    # A simple way to short circuit the delivery of an email from within
    # deliver_* methods defined in ActionMailer::Base subclases.
    def do_not_deliver!
      raise AbortDeliveryError
    end

    def process(*args)
      begin
        super *args
      rescue AbortDeliveryError
        self.message = BlackholeMailMessage
      end
    end
  end
end

class AbortDeliveryError < StandardError
end

class BlackholeMailMessage < Mail::Message
  def self.deliver
    false
  end
end
