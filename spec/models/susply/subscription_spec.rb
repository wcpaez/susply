require 'spec_helper'

module Susply
  describe Subscription, type: :model do
    let(:time) { Time.zone.now }
    describe "validations" do
      it "shoulda validate" do
        subscription = build(:susply_subscription)
        expect(subscription).to be_valid
      end

      it "belogs to owner" do
        a = Susply::Subscription.reflect_on_association(:owner)
        expect(a.macro).to eq :belongs_to
      end

      it "sets to owner the class on susply initializer" do
        a = Susply::Subscription.reflect_on_association(:owner)
        expect(a.options[:class_name]).to eq Susply.subscription_owner_class
      end

      it "belongs to plan" do
        a = Susply::Subscription.reflect_on_association(:plan)
        expect(a.macro).to eq :belongs_to
      end

      it "sets the plan class on susply" do
        a = Susply::Subscription.reflect_on_association(:plan)
        expect(a.options[:class_name]).to eq 'Susply::Plan'
      end

      it "validates presence of owner_id" do
        subscription = build(:susply_subscription, owner_id: nil)
        expect(subscription).not_to be_valid
      end

      it "validates presence of plan_id" do
        subscription = build(:susply_subscription, plan_id: nil)
        expect(subscription).not_to be_valid
      end

      it "validates presence of start" do
        subscription = build(:susply_subscription, start: nil)
        expect(subscription).not_to be_valid
      end

      it "validates presence of current period start" do
        subscription = build(:susply_subscription, current_period_start: nil)
        expect(subscription).not_to be_valid
      end

      it "validates presence of current_period_end" do
        subscription = build(:susply_subscription, current_period_end: nil)
        expect(subscription).not_to be_valid
      end

      it "should validates quantity is an integer" do
        subscription = build(:susply_subscription, quantity: 12.2)
        expect(subscription).not_to be_valid
      end
      
      it "should validates price is greater than 0" do
        subscription = build(:susply_subscription, quantity: 0)
        expect(subscription).not_to be_valid
      end
    end

    describe "#name" do
      it "returns plan name" do
        name = 'Basic plan'
        plan = create(:susply_plan, name: name)
        subscription = build(:susply_subscription, plan: plan)

        expect(subscription.name).to eq name
      end
    end

    describe "#price" do
      it "returns plan price" do
        price = 5
        plan = create(:susply_plan, price: price)
        subscription = build(:susply_subscription, plan: plan)

        expect(subscription.price).to eq price
      end
    end

    describe "#active?" do
      it "returns true when deactivated at is not present" do
        subscription = build(:susply_subscription, deactivated_at: nil)

        expect(subscription.active?).to eq true
      end
      
      it "returns false when deactivated at is present" do
        subscription = build(:susply_subscription, 
                             deactivated_at: Time.zone.now)

        expect(subscription.active?).to eq false
      end
    end

    describe "#expired?" do
      it "returns true when current_period_end is less than now" do
        subscription = build(:susply_subscription,
                             current_period_end: time - 1.day)

        expect(subscription).to be_expired
      end

      it "returns false when current_period_end is greater than now" do
        subscription = build(:susply_subscription,
                             current_period_end: time + 1.day)

        expect(subscription).not_to be_expired
      end
    end

    describe "allowed_to_renew?" do
      it "returns false when is not active" do
        subscription = build(:susply_subscription, :inactive)

        expect(subscription).not_to be_allowed_to_renew
      end

      it "returns false when is active and not expired" do
        subscription = build(:susply_subscription, :active,
                             current_period_end: time + 1.day)

        expect(subscription).not_to be_allowed_to_renew
      end

      it "returns true when is active and expired" do
        subscription = build(:susply_subscription, :active,
                             current_period_end: time - 1.day)

        expect(subscription).to be_allowed_to_renew
      end
    end
  end
end
