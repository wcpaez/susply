require 'spec_helper'

module Susply
  describe CancelSubscription do
    it "updates deactivated at with the current time" do
      subscription = create(:susply_subscription, deactivated_at: nil)
      s = Susply::CancelSubscription.call(subscription)

      expect(s.deactivated_at).to be_within(1.second).of(Time.zone.now)
    end

    it "does not updates deactivated at when its already cancelled" do
      time = Time.zone.now - 3.days
      subscription = create(:susply_subscription, deactivated_at: time)
      s = Susply::CancelSubscription.call(subscription)

      expect(s.deactivated_at).to eq time
    end
  end
end
