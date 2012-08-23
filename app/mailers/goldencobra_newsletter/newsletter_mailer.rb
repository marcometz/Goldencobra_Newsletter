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
      if @user && @user.present? && newsletter.newsletter_tags.include?(@email_template.template_tag)
        mail to: @user.email, bcc: "#{@email_template.bcc}", :css => "/goldencobra_events/email", :subject => subject
      else
        do_not_deliver!
      end
    end

    def confirm_cancel_subscription(user, email_template)
      @user = user
      @template = email_template
      if @user && @template
        mail to: @user.email, subject: t(:subscription_canceled, scope: [:email, :subject]), :css => "/goldencobra_events/email"
      else
        do_not_deliver!
      end
    end

    def confirm_subscription(email, email_template_tag)
      @user = User.find_by_email(email)
      @template = GoldencobraEmailTemplates::EmailTemplate.find_by_template_tag(email_template_tag)
      if @user && @template
        mail to: @user.email, subject: t(:subscription_confirmed, scope: [:email, :subject]), :css => "/goldencobra_events/email"
      else
        do_not_deliver!
      end
    end

    def double_opt_in(email, newsletter_tag)
      @user = User.find_by_email(email)
      @template = GoldencobraEmailTemplates::EmailTemplate.find_by_template_tag(newsletter_tag)
      if @user && @template
        mail to: @user.email, subject: t(:double_opt_in, scope: [:email, :subject]), :css => "/goldencobra_events/email"
      else
        do_not_deliver!
      end
    end

    def send_campaign_email(recipients, campaign)
      @campaign = campaign
      if recipients.count > 0
        recipients.each do |user|
          @user = user
          mail(to: @user.email, subject: @campaign.subject) do |format|
            format.html { render inline: @campaign.layout }
            #format.text { render text: @campaign.plaintext }
          end
          user.newsletter_registration.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: #{@campaign.title}", :description => "email: #{user.email}")
        end
      else
        do_not_deliver!
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
