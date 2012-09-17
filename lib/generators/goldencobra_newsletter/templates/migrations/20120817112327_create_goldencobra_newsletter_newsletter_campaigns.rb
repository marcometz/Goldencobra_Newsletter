class CreateGoldencobraNewsletterNewsletterCampaigns < ActiveRecord::Migration
  def change
    create_table :goldencobra_newsletter_newsletter_campaigns do |t|
      t.string :title
      t.string :subject
      t.string :from
      t.text :layout

      t.timestamps
    end
  end
end
