require 'spec_helper'

describe GoldencobraNewsletter::NewsletterRegistration do
  before(:each) do

  end

  describe "Registration" do
    it "should reject a registration if there is no company_name given" do
      FactoryGirl.build(:newsletter_registration, :company_name => nil).should_not be_valid
    end

    before(:each) do
      user = mock_model(User, firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
      #@newsletter_registration = mock_model(GoldencobraNewsletter::NewsletterRegistration, user: user, is_subscriber: true, company_name: "ikusei")
    end
    
    it "should have a newsletter_tag when signing up" do
      user = mock_model(User, firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
      @newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.create(user: user, is_subscriber: true, company_name: "ikusei")
      @newsletter_registration.newsletter_tags="newsletter-cloudforum"
      @newsletter_registration.newsletter_tags.should == "newsletter-cloudforum"
    end
  end

  describe "Email" do
    it "should have an 'unsubscribe' link inside" do
      # create new email with tag
      # check for unsubcribe link with tag
    end

    it "should unsubscribe when following 'unsubscribe' link" do
      # create and send email
      # follow 'unsubscribe' link
      # check for successful unsubscribe
    end
  end
end
