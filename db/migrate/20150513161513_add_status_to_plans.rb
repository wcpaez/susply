class AddStatusToPlans < ActiveRecord::Migration
  def change
    add_column :susply_plans, :active, :boolean
    add_column :susply_plans, :published, :boolean
  end
end
