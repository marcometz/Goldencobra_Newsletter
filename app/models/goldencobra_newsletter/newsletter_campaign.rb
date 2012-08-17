# == Schema Information
#
# Table name: goldencobra_newsletter_newsletter_campaigns
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  subject    :string(255)
#  from       :string(255)
#  layout     :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module GoldencobraNewsletter
  class NewsletterCampaign < ActiveRecord::Base
    attr_accessible :from, :subject, :title, :layout
  end
end
