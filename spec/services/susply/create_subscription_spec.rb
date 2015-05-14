require 'spec_helper'

module Susply
  describe CreateSubscription do
    it "creates the subscription" do
      
      owner = Organization.create(name: "Iokero", subdomain: 'iokero')
      plan = create(:susply_plan, interval: 'monthly')

      subscription = Susply::CreateSubscription.call(owner, plan)

      expect(subscription.id).not_to be_nil
      expect(subscription.owner).to eq owner
      expect(subscription.plan).to eq plan
      expect(subscription.quantity).to eq 1
      expect(subscription.start).to be_within(1.second).of(Time.zone.now)
      expect(subscription.current_period_start).
        to be_within(2.second).of(Time.zone.now)
      expect(subscription.current_period_end).
        to be_within(2.second).of(Time.zone.now + 1.month)
    end
  end
end
