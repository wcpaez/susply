module Susply
  class ChangeSubscription
    def self.call(owner, new_plan)
      if owner.has_active_subscription?
        Susply::CreatePayment.call(owner.active_subscription, "plan_change")
        Susply::CancelSubscription.call(owner.active_subscription)
      end

      new_subscription = Susply::CreateSubscription.call(owner, new_plan)

      new_subscription
    end
  end
end
