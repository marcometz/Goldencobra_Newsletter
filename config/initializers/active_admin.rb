ActiveAdmin.setup do |config|
  config.load_paths << "#{GoldencobraNewsletter::Engine.root}/app/admin/"
  config.register_stylesheet 'goldencobra_newsletter/active_admin'
end
