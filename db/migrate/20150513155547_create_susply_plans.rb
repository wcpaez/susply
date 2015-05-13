class CreateSusplyPlans < ActiveRecord::Migration
  def change
    create_table :susply_plans do |t|
      t.string :sku
      t.string :name
      t.string :description
      t.integer :price
      t.string :interval
      t.boolean :highlight

      t.timestamps null: false
    end
  end
end
