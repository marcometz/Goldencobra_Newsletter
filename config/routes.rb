GoldencobraNewsletter::Engine.routes.draw do

  # get 'newsletters/register'
  match 'newsletters/register' => 'newsletters#register'
  match 'newsletters/unsubscribe' => 'newsletters#unsubscribe'



  # => 'events#register', :as => :register_event

end
