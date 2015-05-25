module Susply
  class Subscription < ActiveRecord::Base
    belongs_to :owner, class_name: Susply.subscription_owner_class
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

    def active?
      deactivated_at.nil?
    end

    def expired?
      current_period_end < Time.zone.now
    end

    def allowed_to_renew?
      active? && expired?
    end
  end
end
