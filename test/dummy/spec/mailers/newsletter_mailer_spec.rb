require 'spec_helper'
require 'email_spec'

describe GoldencobraNewsletter::NewsletterMailer do
  describe "Newsletter" do

    before(:each) do
      @user = mock_model(User, firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
      @newsletter_registration = mock_model(GoldencobraNewsletter::NewsletterRegistration, user: @user, is_subscriber: true, company_name: "ikusei")
    end

    it "should send a newsletter with template" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate)
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
      ActionMailer::Base.deliveries.length.should > 0
    end

    it "should not send a newsletter if user is not subscriber" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate)
      newsletter_registration = mock_model(GoldencobraNewsletter::NewsletterRegistration, user: @user, is_subscriber: false, company_name: "ikusei")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(newsletter_registration, newsletter_template).deliver
      ActionMailer::Base.deliveries.length.should == 0
    end

    it "should have correct subject and body contents" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate, subject: "My Awesome Email", title: "My Email title", content_html: "<div id='awesome-body'>My content</div>")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
      email.should have_subject("My Awesome Email")
      email.should have_body_text("My content")
    end

    it "template should have a tag and display it inside of email" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate, template_tag: "Monthly")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
    end

    describe "Newsletter unsubscribing" do

      before(:each) do
        @newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate,
                                         subject: "My Awesome Email",
                                         title: "My Email title",
                                         content_html: "<div id='awesome-body'>My content</div>",
                                         template_tag: "newsletter_monthly")
      end

      it "should have an 'unsubscribe' link inside" do
        @email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, @newsletter_template).deliver
        @email.should have_body_text("Von diesem Newsletter <a href=\'http://cloudforum.tagesspiegel.de/newsletters/unsubscribe?tag=newsletter_monthly&email=holger@ikusei.de\'>abmelden</a>")
      end

      it "should unsubscribe from the chosen newsletter when following 'unsubscribe' link" do
        email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, @newsletter_template).deliver
        open_email('holger@ikusei.de')
        visit_in_email "http://cloudforum.tagesspiegel.de/newsletters/unsubscribe?tag=newsletter_monthly&email=holger@ikusei.de"
        # follow 'unsubscribe' link
        # check for successful unsubscribe
      end
    end

  end
end
