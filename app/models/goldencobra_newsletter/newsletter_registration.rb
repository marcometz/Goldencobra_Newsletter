# == Schema Information
#
# Table name: goldencobra_newsletter_newsletter_registrations
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  company_name    :string(255)
#  is_subscriber   :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  newsletter_tags :string(255)
#  location_id     :integer
#

module GoldencobraNewsletter
  class NewsletterRegistration < ActiveRecord::Base
    LiquidParser = {}
    belongs_to :user, :class_name => User
    belongs_to :location, class_name: Goldencobra::Location
    validates_presence_of :company_name
    has_many :vita_steps, :as => :loggable, :class_name => Goldencobra::Vita
    liquid_methods :newsletter_tags
    attr_accessible :company_name, :is_subscriber, :newsletter_tags, :user_attributes, :user, :user_id, :location_id, :location_attributes
    accepts_nested_attributes_for :location, :user

    def full_user_name
      [self.user.firstname, self.user.lastname].join(" ")
    end

    def self.generate_random_dummy_password
        Digest::MD5.new.hexdigest("pass-#{Time.now.to_f}")
    end

    scope :is_subscriber, where(:is_subscriber => true)
    scope :is_no_subscriber, where(:is_subscriber => false)

    scope :vita_title_eq, lambda { |text| includes(:vita_steps).where(:goldencobra_vita => {:title => text}) }
    search_methods :vita_title_eq

    scope :vita_date_gte, lambda { |datum| includes(:vita_steps).where("goldencobra_vita.created_at > '#{datum} 00:00'") }
    search_methods :vita_date_gte

    scope :vita_date_lte, lambda { |datum| includes(:vita_steps).where("goldencobra_vita.created_at < '#{datum} 00:00'") }
    search_methods :vita_date_lte

    scope :firstname_contains, lambda { |text| includes(:user).where('users.firstname LIKE ?', text) }
    search_methods :firstname_contains

    scope :lastname_contains, lambda { |text| includes(:user).where('users.lastname LIKE ?', text) }
    search_methods :lastname_contains


    def self.render_formular(tag_name)
    end

    def unsubscribe!(email)#, newsletter_tag)
      user = User.find_by_email(email)
      newsreg = GoldencobraNewsletter::NewsletterRegistration.find_by_user_id(user.id)
      # tags = newsreg.newsletter_tags.split(",")
      # tags.delete(newsletter_tag)
      # newsreg.update_attributes(newsletter_tags: tags.compact.join(","))
      newsreg.update_attributes(newsletter_tags: nil)
      # @template = GoldencobraEmailTemplates::EmailTemplate.find_by_template_tag(newsletter_tag)
      GoldencobraNewsletter::NewsletterMailer.confirm_cancel_subscription(user).deliver#, @template).deliver
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
        #GoldencobraNewsletter::NewsletterMailer.confirm_subscription(email, newsletter_tag).deliver
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
