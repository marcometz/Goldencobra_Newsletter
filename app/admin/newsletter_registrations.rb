ActiveAdmin.register GoldencobraNewsletter::NewsletterRegistration, :as => "Newsletter Registration" do
  # menu :parent => "Newsletter Registration"

  index do
    column :user do |nr|
      [nr.user.firstname, nr.user.lastname].join(" ")
    end
    column :company_name
    column :is_subscriber

    default_actions
  end


  show :title => newsletter_registration.user.lastname do
    panel "User" do
      attributes_table_for newsletter_registration.user do
        # [:firstname, :lastname, :title, :email, :gender, :function, :phone, :fax, :facebook, :twitter, :linkedin, :xing, :googleplus, :created_at, :updated_at].each do |aa|
        #   row aa
      end
    end
  end
    # panel "Company" do
    #   if applicant.company
    #     attributes_table_for applicant.company do
    #       [:title, :legal_form, :phone, :fax, :homepage, :sector].each do |aa|
    #         row aa
    #       end
    #     end
    #     if applicant.company.location
    #       attributes_table_for applicant.company.location do
    #         [:street, :zip, :city, :region, :country].each do |aa|
    #           row aa
    #         end
    #       end
    #     end
    #   end
    # end
    # panel "Registrations" do
    #   table do
    #     tr do
    #       ["Event title", "Pricegroup title", "Price", "Registered at"].each do |sa|
    #         th sa
    #       end
    #     end
    #     applicant.event_registrations.each do |ereg|
    #       tr do
    #         [ereg.event_pricegroup.event.title, ereg.event_pricegroup.title, number_to_currency(ereg.event_pricegroup.price, :locale => :de), ereg.created_at].each do |esa|
    #           td esa
    #         end
    #       end
    #     end
    #     tr :class => "total" do
    #       td ""
    #       td ""
    #       td number_to_currency(applicant.total_price, :locale => :de)
    #       td ""
    #     end
    #   end


  # form :html => { :enctype => "multipart/form-data" } do |f|
  #   f.inputs "Allgemein" do
  #     f.input :title, :hint => "Der Titel des Panels, kann Leerzeichen und Sonderzeichen enthalten"
  #     f.input :description, :hint => "Die Beschreibung des Panels"
  #     f.input :link_url, :hint => "Link zur Panel-Seite"
  #   end

  #   f.inputs "Informationen" do
  #     f.input :sponsors, :as => :check_boxes, :collection => GoldencobraEvents::Sponsor.find(:all, :order => "title ASC")
  #   end

  #   f.buttons
  # end
end
