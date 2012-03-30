class AddNewsletterToGoldencobraArticle < ActiveRecord::Migration
  def change
    add_column :goldencobra_articles, :newsletter, :boolean

  end
end
