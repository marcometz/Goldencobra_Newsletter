GoldencobraNewsletter::Engine.routes.draw do

  match 'newsletters/register' => 'newsletters#register'
  match 'newsletters/unsubscribe' => 'newsletters#unsubscribe'
  match 'newsletters/subscribe' => 'newsletters#subscribe'
end
