require 'spec_helper'

module Susply
  describe CreatePayment do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 
    it "returns nil when its passes a closed subscription" do
      s = create(:susply_subscription, :inactive)
      payment = Susply::CreatePayment.call(s, 'my_type')

      expect(payment).to be_nil
    end

    context "when passes an active subscription" do
      let(:owner) {owner_class.create(name: 'iokero')}
      it "sets the payment owner to the subscription owner" do
        s = create(:susply_subscription, :active, owner: owner)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.owner).to be owner
      end

      it "sets the payment plan to the subscription plan" do
        plan = create(:susply_plan, sku: 'awea')
        s = create(:susply_subscription, :active, owner: owner, plan: plan)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.plan).to be plan
      end

      it "sets the payment subscription to the passed subscription" do
        s = create(:susply_subscription, :active, owner: owner)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.subscription).to be s
      end

      it "sets the payment amount proratated for no renovation type" do
        allow(Susply::Prorate).to receive(:call) {5}
        s = create(:susply_subscription, :active, owner: owner)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.amount).to be 5
      end

      it "sets the payment mount as full plan price for renovation type" do
        plan = create(:susply_plan, price: 25)
        s = create(:susply_subscription, :active, owner: owner, plan: plan)
        payment = Susply::CreatePayment.call(s, 'plan_renovation')

        expect(payment.amount).to be 25
      end

      it "sets the payment type to the passed generated type" do
        s = create(:susply_subscription, :active, owner: owner)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.generated_type).to eq 'plan_change'
      end

      it "sets the payment period start" do
        s = create(:susply_subscription, :active, owner: owner,
                  current_period_start: Time.zone.now - 3.hours)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.period_start).to eq s.current_period_start
      end

      it "sets the payment period end" do
        s = create(:susply_subscription, :active, owner: owner,
                  current_period_end: Time.zone.now + 3.hours)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.period_end).to eq s.current_period_end
      end

      it "sets the status to generated" do
        s = create(:susply_subscription, :active, owner: owner)
        payment = Susply::CreatePayment.call(s, 'plan_change')

        expect(payment.status).to eq 'generated'
      end
    end
  end
end
