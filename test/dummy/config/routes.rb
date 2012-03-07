Rails.application.routes.draw do

  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config
  mount GoldencobraNewsletter::Engine => "/goldencobra_newsletter"
  mount Goldencobra::Engine => "/"
end
