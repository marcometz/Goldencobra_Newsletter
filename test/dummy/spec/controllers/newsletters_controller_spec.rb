require 'spec_helper'

describe GoldencobraNewsletter::NewslettersController do
#  describe "GET unsubscribe" do
#    it "should show a fallback view when unsuccessfully unsubscribing from a newsletter" do
#      get :unsubscribe
#      response.should render_template("goldencobra_newsletter/newsletters/no_registration_found, layouts/goldencobra_newsletter/application")
#    end
#
#    it "should show success when unsubscribing from a newsletter" do
#        @user = User.create(firstname: "Tim", lastname: "Test", email: "holger@ikusei.de", password: "123456", password_confirmation: "123456")
#        @newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.create(newsletter_tags: "default",
#                                                                                       user: @user,
#                                                                                       is_subscriber: true,
#                                                                                       company_name: "ikusei")
#        @newsletter_template = GoldencobraEmailTemplates::EmailTemplate.create(
#                                         subject: "My Awesome Email",
#                                         title: "My Email title",
#                                         content_html: "<div id='awesome-body'>My content</div>",
#                                         template_tag: "default")
#
#      get :unsubscribe, tag: "default", token: @user.authentication_token
#      response.should render_template('/goldencobra_newsletter/newsletters/unsubscribe')
#    end
#  end
end
