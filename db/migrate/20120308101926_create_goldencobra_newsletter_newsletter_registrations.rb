class CreateGoldencobraNewsletterNewsletterRegistrations < ActiveRecord::Migration
  def change
    create_table :goldencobra_newsletter_newsletter_registrations do |t|
      t.integer :user_id
      t.string :company_name
      t.boolean :is_subscriber

      t.timestamps
    end
  end
end
