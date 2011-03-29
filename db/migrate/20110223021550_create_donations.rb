class CreateDonations < ActiveRecord::Migration
  def self.up
    create_table "donations", :force => true do |t|
      t.float :amount, :precision => 2
      t.integer :user_id
      t.integer :weekdate_id
      t.integer :budget_id

      t.timestamps
    end

    #Donation.new.fill_db

  end

  def self.down
    drop_table :donations
  end
end
