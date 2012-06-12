# == Schema Information
#
# Table name: goldencobra_newsletter_newsletter_registrations
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  company_name    :string(255)
#  is_subscriber   :boolean(1)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#  newsletter_tags :string(255)
#

module GoldencobraNewsletter
  class NewsletterRegistration < ActiveRecord::Base
    LiquidParser = {}
    belongs_to :user, :class_name => User
    validates_presence_of :company_name
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    liquid_methods :newsletter_tags

    attr_accessible :company_name, :is_subscriber, :newsletter_tags, :user_attributes, :user

    def full_user_name
      [self.user.firstname, self.user.lastname].join(" ")
    end

    def self.generate_random_dummy_password
        Digest::MD5.new.hexdigest("pass-#{Time.now.to_f}")
    end
    
    
    def self.render_formular(tag_name)
      
    end

    def unsubscribe!(email, newsletter_tag)
      user = User.find_by_email(email)
      newsreg = GoldencobraNewsletter::NewsletterRegistration.find_by_user_id(user.id)
      tags = []
      tags << newsreg.newsletter_tags
      tags.delete(newsletter_tag)
      newsreg.update_attributes(newsletter_tags: tags.compact.join(","))
      @template = GoldencobraEmailTemplates::EmailTemplate.find_by_template_tag(newsletter_tag)
      GoldencobraNewsletter::NewsletterMailer.confirm_cancel_subscription(@user, @template).deliver
    end

    def subscribe!(email, newsletter_tag)
      user = User.find_by_email(email)
      newsreg = GoldencobraNewsletter::NewsletterRegistration.find_by_user_id(user.id)
      tags = []
      tags << newsreg.newsletter_tags
      tags << newsletter_tag.to_s
      updated_tags = tags.compact.uniq.join(",")
      if newsreg.update_attributes(newsletter_tags: updated_tags)
        logger.warn("=============")
        logger.warn("mail wird gesendet")
        GoldencobraNewsletter::NewsletterMailer.confirm_subscription(email, newsletter_tag).deliver
      end
    end

    def send_double_opt_in(email, newsletter_tag)
      user = User.find_by_email(email)
      newsreg = GoldencobraNewsletter::NewsletterRegistration.find_by_user_id(user.id)
      if user && newsreg
        GoldencobraNewsletter::NewsletterMailer.double_opt_in(email, newsletter_tag).deliver
      end
    end
  end
end
