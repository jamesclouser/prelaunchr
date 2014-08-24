class AddIsAffiliateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_affiliate, :boolean, :default => false
  end
end
