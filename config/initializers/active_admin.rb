ActiveAdmin.setup do |config|
 config.register_stylesheet 'goldencobra_newsletter/active_admin'
 config.load_paths << "#{Goldencobra::Engine.root}/app/admin/"
 unless Rails.env == "production"
   config.load_paths << "#{GoldencobraNewsletter::Engine.root}/app/admin/"
 end
 config.load_paths = config.load_paths.uniq
end

# ActiveAdmin.unload!
# ActiveAdmin.load!


