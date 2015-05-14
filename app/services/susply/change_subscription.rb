module Susply
  class ChangeSubscription
    def self.call(owner, new_plan)
      active_subscription = owner.active_subscription

      if active_subscription
        Susply::CancelSubscription.call(active_subscription)
      end

      new_subscription = Susply::CreateSubscription.call(owner, new_plan)

      new_subscription
    end
  end
end
