module Susply
  module Prorate
    def self.call(subscription)
      return 0 unless subscription.active?
      plan = subscription.plan
      days = used_days(subscription)
      calculate_used_amount(plan, days)
    end

    def self.used_days(subscription)
      (Time.zone.today.to_date - subscription.current_period_start.to_date).to_i
    end

    def self.calculate_used_amount(plan, used_days)
      if plan.interval == "yearly"
        (plan.price * 1.2 * used_days / 365).ceil
      else
        (plan.price * used_days / 30.0).ceil
      end
    end
  end
end
