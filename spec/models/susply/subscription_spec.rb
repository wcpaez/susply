require 'spec_helper'

module Susply
  describe Subscription, type: :model do
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
        expect(a.options[:class_name]).to eq Susply.owner_class
      end

      it "belogs to plan" do
        a = Susply::Subscription.reflect_on_association(:plan)
        expect(a.macro).to eq :belongs_to
      end

      it "sets to owner the class on susply initializer" do
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
  end
end
