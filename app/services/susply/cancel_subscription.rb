module Susply
  class CancelSubscription
    def self.call(subscription)
      if subscription.active?
        subscription.update_attributes(deactivated_at: Time.zone.now)
      end

      subscription
    end
  end
end
