desc "seed data for goldencobra newsletter"
task :seed do
  Goldencobra::Article.create!(content: "", url_name: "newsletter-site", breadcrumb: "newsletter-site", title: "newsletter-site")
end
