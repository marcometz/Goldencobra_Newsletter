ActiveAdmin.register GoldencobraNewsletter::NewsletterRegistration, :as => "Newsletter Registration" do
  # menu :parent => "Newsletter Registration"
  controller.authorize_resource :class => GoldencobraNewsletter::NewsletterRegistration
  filter :company_name
  filter :is_subscriber, :as => :select
  filter :vita_title, :as => :select, :collection => ["Mail delivered: newsletter", "Mail delivery failed: newsletter"]
  filter :vita_date, :as => :date_range
  
  scope "Alle", :scoped, :default => true
  scope :is_subscriber
  scope :is_no_subscriber
  
  
  index do
    selectable_column
    column :user do |nr|
      [nr.user.firstname, nr.user.lastname].join(" ") if nr.user && nr.user.firstname && nr.user.lastname
    end
    column "Email" do |u|
      u.user.email if u.user && u.user.email
    end
    column :company_name
    column :newsletter_tags
    column :is_subscriber do |nr|
      nr.is_subscriber
    end
    default_actions
  end

  actions :all, :except => [:new]
  
  show :title => :full_user_name do
    attributes_table do
      panel "User" do
        attributes_table_for newsletter_registration.user do
          [:firstname, :lastname, :title, :email, :gender].each do |aa|
            row aa
          end
        end
      end
      row :company_name
      row :is_subscriber
    end
    panel "Vita" do
      table do
        tr do
          th t('activerecord.attributes.vita.title')
          th t('activerecord.attributes.vita.description')
          th t('activerecord.attributes.vita.created_at')
        end
        newsletter_registration.vita_steps.each do |vita|
          tr do
            td vita.title
            td vita.description
            td l(vita.created_at, format: :short)
          end
        end
      end
    end #end panel vita
  end
  
  if ActiveRecord::Base.connection.table_exists?("goldencobra_email_templates_email_templates")
    GoldencobraEmailTemplates::EmailTemplate.all.each do |emailtemplate|
      batch_action "E-Mail senden: #{emailtemplate.title}", :confirm => "#{emailtemplate.title}: sind Sie sicher?" do |selection|
        GoldencobraNewsletter::NewsletterRegistration.find(selection).each do |newsreg|
          if newsreg.is_subscriber
            if newsreg.user.email.present? 
              GoldencobraNewsletter::NewsletterMailer.email_with_template(newsreg, emailtemplate).deliver unless Rails.env == "test"
              newsreg.vita_steps << Goldencobra::Vita.create(:title => "Mail delivered: newsletter", :description => "email: #{newsreg.user.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
            else
              newsreg.vita_steps << Goldencobra::Vita.create(:title => "Mail delivery failed: newsletter", :description => "email: #{newsreg.user.email}, user: admin #{current_user.id}, email_template: #{emailtemplate.id}")
            end
          end
        end
        redirect_to :action => :index, :notice => "Newsletter wurden versendet"
      end
    end
  end
  
    

end
