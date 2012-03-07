class AddNewsletterToUsers < ActiveRecord::Migration
  def change
    add_column :users, :newsletter, :boolean unless ActiveRecord::Base.connection.column_exists?(:users, :newsletter)
  end
end
