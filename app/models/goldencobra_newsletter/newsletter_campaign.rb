# == Schema Information
#
# Table name: goldencobra_newsletter_newsletter_campaigns
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  subject       :string(255)
#  from          :string(255)
#  layout        :text
#  plaintext     :text
#  selected_tags :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

module GoldencobraNewsletter
  class NewsletterCampaign < ActiveRecord::Base

    def selected_tags_display=(wert)
      self.selected_tags = wert.flatten.uniq.compact.delete_if{|a|a==""}.join(",")
    end

    def selected_tags_display
      self.selected_tags.split(",") if self.selected_tags.present?
    end
  end
end
