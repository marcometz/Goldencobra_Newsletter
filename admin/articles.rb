ActiveAdmin.register Goldencobra::Article, :as => "Article" do
  menu parent: "Content-Management", label: "Artikel", :if => proc{can?(:read, Goldencobra::Article)}

  sidebar :newsletter_module, only: [:edit] do
    render "/goldencobra_newsletter/admin/newsletters/newsletter_module_sidebar"
  end
  
end
