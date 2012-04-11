#ActiveAdmin.setup do |config|
#  config.register_stylesheet 'goldencobra_newsletter/active_admin'
#end

ActiveAdmin.application.load_paths << "#{GoldencobraNewsletter::Engine.root}/app/admin/"
