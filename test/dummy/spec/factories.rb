require 'factory_girl'

Factory.define :article, :class => Goldencobra::Article do |u|
  u.title "Article Title"
  u.url_name "short-title"
  u.startpage false
  u.active true
end


Factory.define :menue, :class => Goldencobra::Menue do |u|
  u.title 'Nachrichten'
  u.target 'www.ikusei.de'
  u.active true
  u.css_class 'news'
end


Factory.define :admin_user, :class => User do |u|
  u.email 'admin@test.de'
  u.firstname 'Admin'
  u.lastname 'Goldencobra'
  u.password 'secure12'
  u.password_confirmation 'secure12'
  u.confirmed_at "2012-01-09 14:28:58"
end

Factory.define :guest_user, :class => User do |u|
  u.email 'guest@test.de'
  u.password 'secure12'
  u.password_confirmation 'secure12'
end

Factory.define :startpage, :class => Goldencobra::Article do |u|
  u.title "Startseite"
  u.url_name "root"
  u.active true
end

Factory.define :role, :class => Goldencobra::Role do |r|
  r.name "admin"
end


Factory.define :admin_role, :class => Goldencobra::Role do |r|
  r.name "admin"
end

Factory.define :guest_role, :class => Goldencobra::Role do |r|
  r.name "guest"
end

Factory.define :admin_permission, :class => Goldencobra::Permission do |p|
  p.action "manage"
  p.subject_class ":all"
  p.subject_id ""
end

Factory.define :newsletter_registration, :class => GoldencobraNewsletter::NewsletterRegistration do |r|
  r.is_subscriber true
  r.company_name "Amazon Inc."

end
