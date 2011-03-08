class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.string :first, :limit => 50
      t.string :surname, :limit => 50
      t.string :street, :limit => 50
      t.string :po_box, :limit => 50
      t.string :town, :limit => 50
      t.string :state, :limit => 50
      t.string :zip, :limit => 5
      t.string :email, :limit => 50
      t.boolean :status
      t.integer :pledge_id
      t.datetime :created_at
      t.datetime :updated_at

      t.timestamps
    end

    User.new.fill_db

  end

  def self.down
    drop_table :users
  end
end
