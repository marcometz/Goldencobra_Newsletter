ActiveAdmin.register GoldencobraNewsletter::NewsletterRegistration, :as => "Newsletter Registration" do
  menu :if => proc{can?(:update, GoldencobraNewsletter::NewsletterRegistration)}

  controller.authorize_resource :class => GoldencobraNewsletter::NewsletterRegistration
  filter :company_name
  filter :is_subscriber, :as => :select
  filter :vita_title, :as => :select, :collection => ["Mail delivered: newsletter", "Mail delivery failed: newsletter"]
  filter :vita_date, :as => :date_range
  filter :newsletter_tags
  filter :firstname, :as => :string
  filter :lastname, :as => :string

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
            if newsreg.user && newsreg.user.email.present? 
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

  form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "Allgemein", class: "foldable inputs" do
      f.input :company_name
      f.input :is_subscriber
      f.input :newsletter_tags
    end
    f.inputs "User" do
    f.fields_for :user_attributes, f.object.user do |u|
      u.inputs "" do
        u.input :gender, as: :select, include_blank: false, collection: [["Herr", true],["Frau", false]]
        u.input :title
        u.input :firstname
        u.input :lastname
        u.input :email
        u.input :function
        u.input :phone
        u.input :fax
        u.input :facebook
        u.input :twitter
        u.input :linkedin
        u.input :xing
        u.input :googleplus
      end
    end
    end
    f.actions
  end

  controller do
    def update
      @newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.find(params[:id])
      @user = User.find_by_email(params[:newsletter_registration][:user_attributes][:email]) if params[:newsletter_registration][:user_attributes][:email].present?
      if @user
        @user.update_attributes(params[:newsletter_registration][:user_attributes])
      else
        User.create(params[:newsletter_registration][:user_attributes])
      end
      if params[:newsletter_registration][:user_attributes].present?
        params[:newsletter_registration].delete(:user_attributes)
      end
      if @newsletter_registration.update_attributes(params[:newsletter_registration])
        flash[:notice] = "Update successful"
      else
        flash[:error] = "Update not successful"
      end
      redirect_to action: :index
    end
  end

  csv do
    column :id
    column :company_name
    column :is_subscriber
    column :newsletter_tags
    column :created_at
    column :updated_at
    column("Geschlecht"){|nlreg| nlreg.user.gender ? "Herr" : "Frau"}
    column("Titel"){|nlreg| nlreg.user.title }
    column("Vorname"){|nlreg| nlreg.user.firstname }
    column("Nachname"){|nlreg| nlreg.user.lastname }
    column("E-Mail"){|nlreg| nlreg.user.email }
    column("Funktion"){|nlreg| nlreg.user.function }
    column("Telefon"){|nlreg| nlreg.user.phone }
    column("Fax"){|nlreg| nlreg.user.fax }
    column("Facebook"){|nlreg| nlreg.user.facebook }
    column("Twitter"){|nlreg| nlreg.user.twitter }
    column("LinkedIn"){|nlreg| nlreg.user.linkedin }
    column("Xing"){|nlreg| nlreg.user.xing }
    column("Google+"){|nlreg| nlreg.user.googleplus }
  end
end
