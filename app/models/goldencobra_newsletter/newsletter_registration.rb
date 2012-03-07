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
    validates_presence_of :company_name

    def full_user_name
      [user.firstname, user.lastname].join(" ")
    end

    def self.generate_random_dummy_password
        Digest::MD5.new.hexdigest("pass-#{Time.now.to_f}")
    end

  end
end
