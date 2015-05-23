module Susply
  class RenewsSubscription
    def self.call(owner)
      if owner.has_active_subscription?
        subscription = owner.active_subscription
        Susply::CreatePayment.call(subscription, "plan_renovation")
        calculate_renewed_subscription(subscription)
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
