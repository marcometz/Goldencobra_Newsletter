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
