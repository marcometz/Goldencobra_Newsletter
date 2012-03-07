GoldencobraNewsletter::Engine.routes.draw do

  # get 'newsletters/register'
  match 'newsletters/register' => 'newsletters#register'



  # => 'events#register', :as => :register_event

end
