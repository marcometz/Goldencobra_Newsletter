require 'spec_helper'

describe GoldencobraNewsletter::NewslettersController do
  describe "GET unsubscribe" do
    it "should show a fallback view when unsuccessfully unsubscribing from a newsletter" do
      get :unsubscribe
      #response.should render_template(partial: '/goldencobra_newsletter/newsletters/no_registration_found')
    end
  end
end
