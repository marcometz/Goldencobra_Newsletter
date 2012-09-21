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
      if GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).any?
        link_to "Bearbeiten", edit_admin_newsletter_registration_path(GoldencobraNewsletter::NewsletterRegistration.where(user_id: user.id).first)
      else
        link_to "Bearbeiten", edit_admin_master_datum_path(user.id)
      end
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
    action_item :only => :edit do
      # _article = @_assigns['article']
      link_to(I18n.t(:create_event_registration_from_master_date, scope: [:active_admin, :action_buttons]), "#")#, :target => "_blank")
    end

    member_action :create_event_registration, :method => :post do
      # article = Goldencobra::Article.find(params[:id])
      # article.update_attributes(:widget_ids => params[:widget_ids])
      # redirect_to :action => :edit, :notice => "Widgets added"
      user = User.find(params[:id])
      reg_user = GoldencobraEvents::RegistrationUser.create_from_master_data(user.id)
      redirect_to edit_admin_applicant_path(reg_user.id)
      # render nothing: true
    end
  end
end
