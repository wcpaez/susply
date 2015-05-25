module Susply
  class RenewsSubscription
    def self.call(owner)
      active_subscription = owner.active_subscription
      if active_subscription && active_subscription.expired?
        Susply::CreatePayment.call(active_subscription, "plan_renovation")
        calculate_renewed_subscription(active_subscription)
      else
        nil
      end
    end

    private
    def self.calculate_renewed_subscription(subscription)
      new_period_start = subscription.current_period_end
      new_period_end = Susply::Calculations.
        end_period_calculation(new_period_start, subscription.plan.interval)
      subscription.quantity = subscription.quantity + 1
      subscription.current_period_start = new_period_start
      subscription.current_period_end = new_period_end
      subscription.save
      subscription
    end
  end
end
