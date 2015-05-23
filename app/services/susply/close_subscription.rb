module Susply
  class CloseSubscription
    def self.call(owner)
      if owner.has_active_subscription?
        Susply::CreatePayment.call(owner.active_subscription, "plan_close")
        Susply::CancelSubscription.call(owner.active_subscription)
      end
    end
  end
end
