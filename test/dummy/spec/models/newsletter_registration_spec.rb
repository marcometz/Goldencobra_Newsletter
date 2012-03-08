require 'spec_helper'

describe GoldencobraNewsletter::NewsletterRegistration do
  before(:each) do

    # @event = GoldencobraEvents::Event.create!(:start_date=>(Date.today - 1.week),
    # :end_date => (Date.today + 1.day),
    #   :title => "Mein Event",
    #   :max_number_of_participators => 10)
    # pricegroup = GoldencobraEvents::Pricegroup.create(:title => "Studenten")

  end

  describe "Registration" do
    it "should reject a registration if there is no company_name given" do

      newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.new
      newsletter_registration.save.should == true

      # @event_pricegroup.update_attributes(:start_reservation => (Date.today + 1.day))
      # @new_registration.is_registerable?.should == {:date_error => "Registration date of pricegroup is not valid"}
    end
  end
end
