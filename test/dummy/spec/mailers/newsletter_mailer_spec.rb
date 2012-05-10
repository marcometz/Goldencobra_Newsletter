require 'spec_helper'

describe GoldencobraNewsletter::NewsletterMailer do
  describe "Newsletter" do

    before(:each) do
      user = mock_model(User, firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
      @newsletter_registration = mock_model(GoldencobraNewsletter::NewsletterRegistration, user: user, is_subscriber: true, company_name: "ikusei")
    end

    it "should send a newsletter with template" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate)
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
      ActionMailer::Base.deliveries.length.should > 0
    end

    it "should have correct subject and body contents" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate, subject: "My Awesome Email", title: "My Email title", content_html: "<div id='awesome-body'>My content</div>")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
      email.should have_subject("My Awesome Email")
      email.should have_body_text("My content")
    end

    describe "Newsletter unsubscribing" do

      it "should successfully unsubscribe a user from the chosen newsletter" do

      end

    end

  end
end
