class AddFieldsToGoldencobraNewsletterNewsletterCampaigns < ActiveRecord::Migration
  def change
    add_column :goldencobra_newsletter_newsletter_campaigns, :plaintext, :text
    add_column :goldencobra_newsletter_newsletter_campaigns, :selected_tags, :string
  end
end
