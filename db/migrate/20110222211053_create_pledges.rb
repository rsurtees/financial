class CreatePledges < ActiveRecord::Migration
  def self.up
    create_table "pledges", :force => true do |t|
      t.float :amount, :precision => 2
      t.string :freq, :limit => 20
      t.float :amount2, :precision => 2
      t.string :freq2, :limit => 20
      t.float :pledge_09, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_10, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_11, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_12, :precision => 10, :scale => 2, :default => 0.0
      t.float :pledge_13, :precision => 10, :scale => 2, :default => 0.0
      t.integer :user_id

      t.timestamps
    end

    Pledge.new.fill_db
  end

  def self.down
    drop_table :pledges
  end
end
