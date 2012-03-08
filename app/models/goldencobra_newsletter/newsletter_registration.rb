# == Schema Information
#
# Table name: goldencobra_newsletter_newsletter_registrations
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  company_name  :string(255)
#  is_subscriber :boolean(1)
#  created_at    :datetime        not null
#  updated_at    :datetime        not null
#

module GoldencobraNewsletter
  class NewsletterRegistration < ActiveRecord::Base
    belongs_to :user, :class_name => User

    def full_user_name
      [user.firstname, user.lastname].join(" ")
    end

  end
end
