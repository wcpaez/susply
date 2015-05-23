require 'spec_helper'

module Susply
  describe CloseSubscription do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 
    let(:time) {Time.zone.today}

    context "when owner has an active subscription" do
      it "closes the active subscription when present" do
        owner = owner_class.create()
        plan = create(:susply_plan)
        subscription = create(:susply_subscription, :active, owner: owner)

        expect(owner.has_active_subscription?).to be true
        Susply::CloseSubscription.call(owner)
        subscription.reload

        expect(subscription).not_to be_active
        expect(owner.has_active_subscription?).to be false
      end

      it "creates a plan_close prorate payment" do
        owner = owner_class.create()
        plan = create(:susply_plan, interval: 'monthly', price: 100)
        subscription = create(:susply_subscription, :active,owner: owner,
                              current_period_start: time - 15.days)

        Susply::CloseSubscription.call(owner)

        payment = owner.payments.last
        expect(payment.generated_type).to eq 'plan_close'
        expect(owner.has_active_subscription?).to be false
      end
    end
  end
end
