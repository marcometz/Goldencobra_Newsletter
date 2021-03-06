ActiveAdmin.register User, :as => "Master Data" do
  controller.authorize_resource :class => User

  if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
    scope :event_registration_present
    scope :event_registration_not_present
    scope :event_and_newsletter_registration_present
  end

  filter :firstname
  filter :lastname
  filter :email
  filter :company_name, as: :string

  index do
    selectable_column
    column :firstname, sortable: true
    column :lastname, sortable: true
    column :email, sortable: true
    if ActiveRecord::Base.connection.table_exists?("goldencobra_events_registration_users")
      column "Anmeldungen" do |user|
        count = GoldencobraEvents::RegistrationUser.where(user_id: user.id).count
        if count > 0
          link_to "Liste von Event-Anmeldungen (#{count})", "/admin/applicants?q%5Bemail_contains%5D=#{user.email}&commit=Filtern&order=id_desc&scope="
        end
      end
    end
    column "" do |user|
      # if GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).any?
        # link_to "Bearbeiten", edit_admin_newsletter_registration_path(GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).first)
      # else
        link_to "Bearbeiten", edit_admin_master_datum_path(user.id)
      # end
    end
  end

 form :html => { :enctype => "multipart/form-data" }  do |f|
    f.actions
    f.inputs "Allgemein", class: "foldable inputs" do
      f.input :gender, as: :select, include_blank: false, collection: [["Herr", true],["Frau", false]]
      f.input :title
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :function
      f.input :phone
      f.input :fax
      f.input :facebook
      f.input :twitter
      f.input :linkedin
      f.input :xing
      f.input :googleplus
    end
    if f.object && f.object.newsletter_registration && f.object.newsletter_registration.location
      f.inputs "Adresse" do
        f.fields_for :newsletter_registration_attributes, f.object.newsletter_registration do |nr|
          nr.fields_for :location_attributes, f.object.newsletter_registration.location do |l|
            l.inputs "" do
              l.input :street
              l.input :zip
              l.input :city
              l.input :country, as: :string
            end
          end
        end
      end
    end
    if f.object && f.object.newsletter_registration
      f.inputs "Newsletterdaten", class: "foldable inputs" do
        f.fields_for :newsletter_registration, f.object.newsletter_registration do |nr|
          nr.inputs "" do
            nr.input :company_name
            nr.input :is_subscriber
            nr.input :newsletter_tags_display, as: :select, collection: GoldencobraNewsletter::NewsletterRegistration.all.map{|nlr| nlr.newsletter_tags.split(",").map{|s|s.strip} if nlr.newsletter_tags.present?}.flatten.uniq.compact,
                input_html: { class: 'chzn-select', style: 'width: 70%;', 'data-placeholder' => 'Newsletter Tags', multiple: true }
          end
        end
      end
    end
    f.inputs "Historie" do
      f.has_many :vita_steps do |step|
        if step.object.new_record?
          step.input :description, as: :string, label: "Eintrag"
          step.input :title, label: "Bearbeiter", hint: "Tragen Sie hier Ihren Namen ein, damit die Aktion zugeordnet werden kann"
        else
          render :partial => "/goldencobra/admin/users/vita_steps", :locals => {:step => step}
        end
      end
    end
    f.actions
  end

  # Neuer Action Button um EventAnmeldung aus Stammdatensatz heraus anzulegen
  # Nur möglich, wenn GoldencobraEvents vorhanden ist
  if defined? GoldencobraEvents
    action_item only: :edit do
      link_to I18n.t(:create_event_registration_from_master_date, scope: [:activeadmin, :action_buttons]), create_event_registration_admin_master_datum_path
    end

    member_action :create_event_registration, method: :get do
      user = User.find(params[:id])
      reg_user = GoldencobraEvents::RegistrationUser.create_from_master_data(user.id)
      redirect_to edit_admin_applicant_path(reg_user.id)
    end
  end

  # Benutzer löschen ("Sperrvermerk erstellen")
  # => Benutzer auf Blacklist setzen,
  # Angemeldet (bei Newsletter) wird "nein",
  # alle Newsletter-tags löschen
  action_item only: :edit do
    link_to I18n.t(:block_user, scope: [:activeadmin, :action_buttons]), block_user_admin_master_datum_path
  end

  member_action :block_user, method: :get do
    newsletter_registration = GoldencobraNewsletter::NewsletterRegistration.where(user_id: params[:id]).first
    if newsletter_registration
      newsletter_registration.update_attributes(is_subscriber: false, newsletter_tags: "blockiert")
      if ActiveRecord::Base.connection.table_exists?("goldencobra_events.email_blacklists") &&
        Goldencobra::Setting.for_key('goldencobra_events.imap.use_blacklist') == "true"

        GoldencobraEvents::EmailBlacklist.create(email_address: newsletter_registration.user.email, status_code: "SPERRVERMERK")
        newsletter_registration.vita_steps << Goldencobra::Vita.create(title: "SPERRVERMERK", description: "E-Mail Adresse wurde gesperrt.")
        u = User.find(params[:id])
        u.vita_steps << Goldencobra::Vita.create(title: "SPERRVERMERK", description: "E-Mail Adresse wurde gesperrt.") if u
      end
    end
    redirect_to admin_master_data_path
  end

  csv do |md|
    column :id
    column :email

    column :created_at
    column :updated_at
    column :gender
    column :title
    column :firstname
    column :lastname
    column :function
    column :phone
    column :fax
    column :facebook
    column :twitter
    column :linkedin
    column :xing
    column :googleplus
    column :newsletter
    column("Company"){|md| md.company_name }
    column("Anmeldungen"){|md| GoldencobraEvents::RegistrationUser.where(user_id: md.id).count}
    column("Street"){ |md| md.location.street }
    column("PLZ"){ |md| md.location.zip }
    column("Stadt"){ |md| md.location.city }
    column("Bezirk"){ |md| md.location.region }
    column("Land"){ |md| md.location.country }
  end


end
