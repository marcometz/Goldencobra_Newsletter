ActiveAdmin.register GoldencobraNewsletter::NewsletterRegistration, :as => "Newsletter Registration" do
  menu :parent => "Newsletter", :if => proc{can?(:update, GoldencobraNewsletter::NewsletterRegistration)}

  controller.authorize_resource :class => GoldencobraNewsletter::NewsletterRegistration
  filter :company_name
  filter :is_subscriber, :as => :select
  filter :vita_title, :as => :select, :collection => ["Mail delivered: newsletter", "Mail delivery failed: newsletter"]
  filter :vita_date, :as => :date_range
  filter :newsletter_tags
  filter :firstname, :as => :string
  filter :lastname, :as => :string
  filter :location_present, :as => :select, :collection => ["Postadresse vorhanden (Strasse & PLZ)"]

  scope "Alle", :scoped, :default => true
  scope :is_subscriber
  scope :is_no_subscriber
  scope :location_present

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
      nr.is_subscriber ? "ja" : "nein"
    end
    column :incl_address do |nr|
      nr.location_present ? "ja" : "nein"
    end
    default_actions
  end

  #actions :all, :except => [:new]

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
    f.inputs "Adresse" do
      f.fields_for :location_attributes, f.object.location do |l|
        l.inputs "" do
          l.input :street
          l.input :zip
          l.input :city
          l.input :country, as: :string
        end
      end
    end
    f.inputs "", class: "foldable inputs" do
      f.input :company_name
      f.input :is_subscriber
      f.input :newsletter_tags, as: :select, collection: GoldencobraNewsletter::NewsletterRegistration.all.map{|nlr| nlr.newsletter_tags.split(",").map{|s|s.strip} if nlr.newsletter_tags.present?}.flatten.uniq!.compact,
          input_html: { class: 'chzn-select', style: 'width: 70%;', 'data-placeholder' => 'Newsletter Tags', multiple: true }
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
        password = GoldencobraNewsletter::NewsletterRegistration.generate_random_dummy_password
        params[:newsletter_registration][:user_attributes][:password] = password
        params[:newsletter_registration][:user_attributes][:password_confirmation] = password
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

    def create
      @user = User.find_by_email(params[:newsletter_registration][:user_attributes][:email]) if params[:newsletter_registration][:user_attributes][:email].present?
      unless @user
        password = GoldencobraNewsletter::NewsletterRegistration.generate_random_dummy_password
        params[:newsletter_registration][:user_attributes][:password] = password
        params[:newsletter_registration][:user_attributes][:password_confirmation] = password
        @user = User.create(params[:newsletter_registration][:user_attributes])
      end
      l = Goldencobra::Location.create(params[:newsletter_registration][:location_attributes])
      GoldencobraNewsletter::NewsletterRegistration.create(company_name: params[:newsletter_registration][:company_name],
                                                           is_subscriber: params[:newsletter_registration][:is_subscriber],
                                                           newsletter_tags: params[:newsletter_registration][:newsletter_tags],
                                                           user_id: @user.id,
                                                           location_id: l.id)
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
    column("Geschlecht"){|nlreg| nlreg.user.present? && nlreg.user.gender ? "Herr" : "Frau"}
    column("Titel")     {|nlreg| nlreg.user.title if nlreg.user.present? }
    column("Vorname")   {|nlreg| nlreg.user.firstname if nlreg.user.present?}
    column("Nachname")  {|nlreg| nlreg.user.lastname if nlreg.user.present?}
    column("E-Mail")    {|nlreg| nlreg.user.email if nlreg.user.present?}
    column("Funktion")  {|nlreg| nlreg.user.function if nlreg.user.present? }
    column("Telefon")   {|nlreg| nlreg.user.phone if nlreg.user.present? }
    column("Fax")       {|nlreg| nlreg.user.fax if nlreg.user.present? }
    column("Facebook")  {|nlreg| nlreg.user.facebook if nlreg.user.present? }
    column("Twitter")   {|nlreg| nlreg.user.twitter if nlreg.user.present? }
    column("LinkedIn")  {|nlreg| nlreg.user.linkedin if nlreg.user.present? }
    column("Xing")      {|nlreg| nlreg.user.xing if nlreg.user.present? }
    column("Strasse")   {|nlreg| nlreg.location.street if nlreg.location.present? }
    column("PLZ")       {|nlreg| nlreg.location.zip if nlreg.location.present? }
    column("Region")    {|nlreg| nlreg.location.region if nlreg.location.present? }
    column("Ort")       {|nlreg| nlreg.location.city if nlreg.location.present? }
    column("Land")      {|nlreg| nlreg.location.country if nlreg.location.present? }
    column("latitude")  {|nlreg| nlreg.location.lat if nlreg.location.present? }
    column("longitude") {|nlreg| nlreg.location.lng if nlreg.location.present? }
  end
end
