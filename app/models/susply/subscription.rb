module Susply
  class Subscription < ActiveRecord::Base
    belongs_to :owner, class_name: Susply.owner_class
    belongs_to :plan, class_name: 'Susply::Plan' 

    validates_presence_of :owner_id, :plan_id, :start,
      :current_period_start, :current_period_end

    validates :quantity, numericality: { only_integer: true, greater_than: 0 }

    def name
      plan.name
    end

    def price
      plan.price
    end
  end
end
