ActiveAdmin.register GoldencobraNewsletter::NewsletterRegistration, :as => "Newsletter Registration" do
  # menu :parent => "Newsletter Registration"
  controller.authorize_resource :class => GoldencobraNewsletter::NewsletterRegistration
  filter :company_name
  
  index do
    column :user do |nr|
      [nr.user.firstname, nr.user.lastname].join(" ")
    end
    column "Email" do |u|
      u.user.email
    end
    column "#{t('active_admin.company')}" do |nr|
      nr.company_name
    end
    column "#{t('active_admin.is_subscriber')}" do |nr|
      nr.is_subscriber #? "#{t('active_admin.yes')}" : "#{t('active_admin.no')}"
    end
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
