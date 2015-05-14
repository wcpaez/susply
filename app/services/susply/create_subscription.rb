module Susply
  class CreateSubscription
    def self.call(owner, plan)
      now = Time.zone.now

      subscription = Susply::Subscription.new do |s|
        s.owner = owner
        s.plan = plan
        s.quantity = 1
        s.start = now
        s.current_period_start = now
        s.current_period_end = Susply::Calculations.
          end_period_calculation(s.current_period_start, plan.interval)
      end
      
      subscription.save

      subscription
    end
  end
end

