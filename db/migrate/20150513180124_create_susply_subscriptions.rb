class CreateSusplySubscriptions < ActiveRecord::Migration
  def change
    create_table :susply_subscriptions do |t|
      t.integer :owner_id
      t.integer :plan_id
      t.timestamp :start
      t.timestamp :current_period_start
      t.timestamp :current_period_end
      t.integer :quantity
      t.timestamp :deactivated_at

      t.timestamps null: false
    end

    add_index :susply_subscriptions, :owner_id
  end
end
