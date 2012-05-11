require 'factory_girl'

FactoryGirl.define do
  factory :article, :class => Goldencobra::Article do |u|
    u.title "Article Title"
    u.url_name "short-title"
    u.startpage false
    u.active true
  end
  
  
  factory :menue, :class => Goldencobra::Menue do |u|
    u.title 'Nachrichten'
    u.target 'www.ikusei.de'
    u.active true
    u.css_class 'news'
  end
  
  
  factory :admin_user, :class => User do |u|
    u.email 'admin@test.de'
    u.firstname 'Admin'
    u.lastname 'Goldencobra'
    u.password 'secure12'
    u.password_confirmation 'secure12'
    u.confirmed_at "2012-01-09 14:28:58"
  end
  
  factory :guest_user, :class => User do |u|
    u.email 'guest@test.de'
    u.password 'secure12'
    u.password_confirmation 'secure12'
  end
  
  factory :startpage, :class => Goldencobra::Article do |u|
    u.title "Startseite"
    u.url_name "root"
    u.active true
  end
  
  factory :role, :class => Goldencobra::Role do |r|
    r.name "admin"
  end
  
  
  factory :admin_role, :class => Goldencobra::Role do |r|
    r.name "admin"
  end
  
  factory :guest_role, :class => Goldencobra::Role do |r|
    r.name "guest"
  end
  
  factory :admin_permission, :class => Goldencobra::Permission do |p|
    p.action "manage"
    p.subject_class ":all"
    p.subject_id ""
  end
  
  factory :newsletter_registration, :class => GoldencobraNewsletter::NewsletterRegistration do |r|
    r.is_subscriber true
    r.company_name "Amazon Inc."
  end

  factory :email_template, class: GoldencobraEmailTemplates::EmailTemplate do |r|
    r.content_html "<div>Emails are great</div>"
    r.content_txt "Emails are great"
    r.title "Newsletters are great"
    r.subject "Awesome Email incoming"
    r.template_tag "my template tag"
  end

  factory :widget, class: Goldencobra::Widget do |w|
    w.title "Testtitel"
    w.content "{% newsletter_form tagname %}"
    w.article_ids [1,2]
  end
end
