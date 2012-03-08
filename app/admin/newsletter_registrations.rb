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

  end

end
