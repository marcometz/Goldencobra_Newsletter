class AddTagToGoldencobraNewsletterNewsletterRegistration < ActiveRecord::Migration
  def change
    add_column :goldencobra_newsletter_newsletter_registrations, :newsletter_tags, :string
  end
end
