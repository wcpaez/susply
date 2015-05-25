require 'spec_helper'

module Susply
  describe RenewsSubscription do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 
    let(:time) {Time.zone.today}

    it "returns nil when owner does not has an active subscription" do
      owner = owner_class.create()
      plan = create(:susply_plan)
      subscription = create(:susply_subscription, :inactive, owner: owner)

      s = Susply::RenewsSubscription.call(owner)

      expect(s).to be_nil
    end

    it "returns nil when active subscription is not expired" do
      owner = owner_class.create()
      plan = create(:susply_plan)
      subscription = create(:susply_subscription, :active,
                            owner: owner, current_period_end: time + 2.days)

      s = Susply::RenewsSubscription.call(owner)

      expect(s).to be_nil
    end

    context "when owner has an active subscription" do
      it "creates a payment of renovation type" do
        owner = owner_class.create()
        plan = create(:susply_plan, interval: 'monthly', price: 101)
        subscription = create(:susply_subscription, :active,
                              owner: owner, plan: plan)

        s = Susply::RenewsSubscription.call(owner)
        payment = owner.payments.last

        expect(payment.generated_type).to eq 'plan_renovation'
        expect(payment.amount).to eq 101
      end

      it "does not creates an extra subscription" do
        owner = owner_class.create()
        subscription = create(:susply_subscription, :active, owner: owner)

        Susply::RenewsSubscription.call(owner)

        expect(owner.subscriptions.count).to be 1
      end

      it "return a subscription with updated attributes" do
        owner = owner_class.create()
        subscription = create(:susply_subscription, :active, owner: owner, 
                              current_period_start: time - 5.days)
        s = Susply::RenewsSubscription.call(owner)

        expect(s.quantity).not_to eq subscription.quantity
        expect(s.current_period_start).
          not_to eq subscription.current_period_start
        expect(s.current_period_end).
          not_to eq subscription.current_period_end
      end

      it "returns updates by one the subscriptions" do
        owner = owner_class.create()
        subscription = create(:susply_subscription, :active, owner: owner, 
                              current_period_start: time - 5.days,
                              quantity: 5)
        s = Susply::RenewsSubscription.call(owner)

        expect(s.quantity).to eq 6
      end

      it "sets the subscription initial date o past end" do
        owner = owner_class.create()
        end_time = time + 6.hours
        subscription = create(:susply_subscription, :active, owner: owner, 
                              current_period_start: time - 5.days,
                              current_period_end: end_time)
        s = Susply::RenewsSubscription.call(owner)

        expect(s.current_period_start).to eq end_time
      end

      it "sets the end period to the given month calculation" do
        owner = owner_class.create()
        end_time = time + 6.hours
        plan = create(:susply_plan, interval: 'monthly')
        subscription = create(:susply_subscription, :active, owner: owner, 
                              plan: plan, current_period_end: end_time)
        s = Susply::RenewsSubscription.call(owner)
        expect(s.current_period_end).to eq(end_time + 1.month)
      end

      it "sets the end period to the given yearly calculation" do
        owner = owner_class.create()
        end_time = time + 2.hours
        plan = create(:susply_plan, interval: 'yearly')
        subscription = create(:susply_subscription, :active, owner: owner, 
                              plan: plan, current_period_end: end_time)
        s = Susply::RenewsSubscription.call(owner)
        expect(s.current_period_end).to eq(end_time + 1.year)
      end
    end
  end
end
