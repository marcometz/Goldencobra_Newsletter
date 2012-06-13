desc "seed data for goldencobra newsletter"
task :seed do
  Goldencobra::Article.create!(content: "", url_name: "404", breadcrumb: "Newsletter Registration", title: "Newsletter Registration")   
end
