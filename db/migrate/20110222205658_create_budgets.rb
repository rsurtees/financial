class CreateBudgets < ActiveRecord::Migration
  def self.up
    create_table :budgets do |t|
      t.string :description, :limit => 50

      t.timestamps
    end

    #Budget.new.fill_db
  end

  def self.down
    drop_table :budgets
  end
end
