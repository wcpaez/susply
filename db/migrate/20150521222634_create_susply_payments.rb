class CreateSusplyPayments < ActiveRecord::Migration
  def change
    create_table :susply_payments do |t|
      t.integer :owner_id
      t.integer :plan_id
      t.integer :subscription_id
      t.integer :amount
      t.datetime :period_start
      t.datetime :period_end
      t.string :status
      t.string :invoice

      t.timestamps null: false
    end

    add_index :susply_payments, :owner_id
  end
end
