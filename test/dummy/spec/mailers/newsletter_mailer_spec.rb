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
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate, subject: "My Awesome Email", title: "My Email title", content_html: "My content")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
      email.should have_subject("My Awesome Email")
      email.should have_body_text(/My content/)
    end

    it "template should have a tag and display it inside of email" do
      newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate, template_tag: "Monthly")
      email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, newsletter_template).deliver
    end

    describe "unsubscribing" do
    include Capybara::DSL

      before(:each) do
        @newsletter_template = mock_model(GoldencobraEmailTemplates::EmailTemplate,
                                         subject: "My Awesome Email",
                                         title: "My Email title",
                                         content_html: "<div id='awesome-body'>My content</div>",
                                         template_tag: "newsletter_monthly")
      end

      it "should have an 'unsubscribe' link inside" do
        @email = GoldencobraNewsletter::NewsletterMailer.email_with_template(@newsletter_registration, @newsletter_template).deliver
        @email.should have_body_text("Von diesem Newsletter <a href=\'http://www.goldencobra.de/newsletters/unsubscribe?tag=newsletter_monthly&token=#{@user.authentication_token}\'>abmelden</a>")
      end

      it "should unsubscribe from the chosen newsletter when following 'unsubscribe' link" do
        user = User.create(firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
        newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.create(newsletter_tags: "newsletter_monthly",
                                                                                       user: user,
                                                                                       is_subscriber: true,
                                                                                       company_name: "ikusei")
        email = GoldencobraNewsletter::NewsletterMailer.email_with_template(newsletter_registration, @newsletter_template).deliver
        open_email('holger@ikusei.de')
        visit "/goldencobra_newsletter/newsletters/unsubscribe?tag=newsletter_monthly&token=#{user.authentication_token}"
        my_newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', user.id).first
        my_newsletter_registration.newsletter_tags.should == ""
      end

      it "should send a confirmation email with a link to sign up again" do
        user = User.create(firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
        newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.create(newsletter_tags: "newsletter_monthly",
                                                                                       user: user,
                                                                                       is_subscriber: true,
                                                                                       company_name: "ikusei")
        newsletter_template = GoldencobraEmailTemplates::EmailTemplate.create(
                                         subject: "My Awesome Email",
                                         title: "My Email title",
                                         content_html: "<div id='awesome-body'>My content</div>",
                                         template_tag: "newsletter_monthly")
        GoldencobraNewsletter::NewsletterMailer.email_with_template(newsletter_registration, newsletter_template).deliver
        visit "/goldencobra_newsletter/newsletters/unsubscribe?tag=newsletter_monthly&token=#{user.authentication_token}"
        last_delivery = ActionMailer::Base.deliveries.last
        last_delivery.should have_subject(/Subscription canceled/)
        last_delivery.should have_body_text("Sie haben sich vom Newsletter 'My Awesome Email' abgemeldet.<br /> Sollte dies versehentlich geschehen sein, koennen Sie sich problemlos <a href='http://www.goldencobra.de/goldencobra_newsletter/newsletters/subscribe?tag=newsletter_monthly&token=#{user.authentication_token}'>wieder anmelden</a>")
      end
    end

    describe "subscribing" do
      include Capybara::DSL

      before(:each) do
        @user = User.create(firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
        #@user.ensure_authentication_token!
        @newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.create(newsletter_tags: "newsletter_monthly",
                                                                                       user: @user,
                                                                                       is_subscriber: true,
                                                                                       company_name: "ikusei")
        @newsletter_template = GoldencobraEmailTemplates::EmailTemplate.create(
                                         subject: "My Awesome Email",
                                         title: "My Email title",
                                         content_html: "<div id='awesome-body'>My content</div>",
                                         template_tag: "newsletter_monthly")
      end

      it "should send a double-opt-in email" do
        visit "/goldencobra_newsletter/newsletters/register?email=holger@ikusei.de&first_name=Holger&last_name=Frohloff&newsletter_tags=newsletter_monthly"
        email = ActionMailer::Base.deliveries.first
        email.should have_subject(/Please confirm subscription/)
      end

      it "should send an email with a link to confirm subscription" do
        GoldencobraNewsletter::NewsletterMailer.double_opt_in(@user.email, @newsletter_template.template_tag).deliver
        email = ActionMailer::Base.deliveries.first
        parse_email_for_link(email, "Anmeldung best&auml;tigen").should == "/newsletters/subscribe?tag=newsletter_monthly&token=#{@user.authentication_token}"
      end

      it "should confirm subscription when visiting link" do
        visit "/goldencobra_newsletter/newsletters/subscribe?tag=newsletter_monthly&token=#{@user.authentication_token}"
        email = ActionMailer::Base.deliveries.last
        email.should have_subject("#{I18n.translate(:subscription_confirmed, scope: [:email, :subject])}")
      end

      it "should re-subscribe a user from a link in email" do
        my_user = User.find_by_email("holger@ikusei.de")
        my_newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', my_user.id).first
        visit "/goldencobra_newsletter/newsletters/unsubscribe?tag=newsletter_monthly&token=#{my_user.authentication_token}"
        GoldencobraNewsletter::NewsletterRegistration.where('user_id = ?', my_user.id).first.newsletter_tags.should == ""
        visit "/goldencobra_newsletter/newsletters/subscribe?token=#{my_user.authentication_token}&tag=newsletter_monthly"
        GoldencobraNewsletter::NewsletterRegistration.find_by_user_id(my_user.id).newsletter_tags.should include("newsletter_monthly")
      end

    end
  end
end
