require 'spec_helper'

module Susply
  describe ChangeSubscription do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 
    let(:time) {Time.zone.today}

    context "when owner has an active subscription" do
      it "closes the active subscription when present" do
        owner = owner_class.create()
        plan = create(:susply_plan)
        subscription = create(:susply_subscription, :active, owner: owner)

        new_subscription = Susply::ChangeSubscription.call(owner, plan)
        subscription.reload

        expect(subscription).not_to be_active
        expect(new_subscription).to be_active
      end

      it "creates a plan_changed prorate payment" do
        owner = owner_class.create()
        plan = create(:susply_plan, interval: 'monthly', price: 100)
        subscription = create(:susply_subscription, :active,owner: owner,
                              current_period_start: time - 15.days)

        Susply::ChangeSubscription.call(owner, plan)

        payment = owner.payments.last
        expect(payment.generated_type).to eq 'plan_change'
      end

      it "creates a new subscription" do
        owner = owner_class.create()
        plan = create(:susply_plan)
        subscription = create(:susply_subscription, :active, owner: owner)
        new_subscription = Susply::ChangeSubscription.call(owner, plan)

        expect(new_subscription.owner).to eq owner
        expect(new_subscription.plan).to eq plan
        expect(new_subscription).to be_active
        expect(owner.subscriptions.count).to eq 2
      end
    end

    context "when owner does not have active subscription" do
      it "does not creates a payment" do
        owner = owner_class.create()
        plan = create(:susply_plan)

        new_subscription = Susply::ChangeSubscription.call(owner, plan)

        expect(owner.payments.count).to eq 0
      end

      it "creates a new subscription" do
        owner = owner_class.create()
        plan = create(:susply_plan)

        new_subscription = Susply::ChangeSubscription.call(owner, plan)

        expect(new_subscription.owner).to eq owner
        expect(new_subscription.plan).to eq plan
        expect(new_subscription).to be_active
      end
    end
  end
end
