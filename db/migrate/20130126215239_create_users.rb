class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :referral_code
      t.string :infusionsoft_affiliate_link
      t.integer :referrer_id, :default => 0

      t.timestamps
    end
  end
end
