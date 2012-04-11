ActiveAdmin.setup do |config|
  config.load_paths << "#{GoldencobraNewsletter::Engine.root}/app/admin/"
  config.load_paths = config.load_paths.uniq
  config.register_stylesheet 'goldencobra_newsletter/active_admin'
end
