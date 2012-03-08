class AddGoldencobraNewsletterIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :goldencobra_newsletter_newsletter_id, :integer

  end
end
