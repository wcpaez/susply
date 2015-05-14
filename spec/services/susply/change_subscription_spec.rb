require 'spec_helper'

module Susply
  describe CancelSubscription do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 
    it "closes the active subscription when present" do
      owner = owner_class.create()
      plan = create(:susply_plan)
      subscription = create(:susply_subscription, :active, owner: owner)

      Susply::ChangeSubscription.call(owner, plan)
      subscription.reload

      expect(subscription).not_to be_active
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
 
