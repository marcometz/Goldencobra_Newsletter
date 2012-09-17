class AddAddressToGoldencobraNewsletterNewsletterRegistrations < ActiveRecord::Migration
  def change
    add_column :goldencobra_newsletter_newsletter_registrations, :location_id, :integer
  end
end
