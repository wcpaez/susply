module Susply
  module CreatePayment
    def self.call(subscription, generated_type)
      if subscription.active?
        amount = calculate_amount(subscription, generated_type)
        payment = Susply::Payment.new do |payment|
          payment.owner = subscription.owner
          payment.plan = subscription.plan
          payment.subscription = subscription
          payment.amount = amount
          payment.generated_type = generated_type
          payment.period_start = subscription.current_period_start
          payment.period_end = subscription.current_period_end
          payment.status = 'generated'
        end
        payment.save!
        payment
      end
    end

    private
    def self.calculate_amount(subscription, generated_type)
      if generated_type == "plan_renovation"
        subscription.plan.price
      else
        Susply::Prorate.call(subscription)
      end
    end
  end
end
