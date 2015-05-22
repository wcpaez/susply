require 'spec_helper'
require 'byebug'

module Susply
  describe OwnerMethods do
    let(:owner_class) { Susply.subscription_owner_class.constantize } 

    describe "sets the has many relationship for subscriptions" do
      it "has many subscriptions" do
        a = owner_class.reflect_on_association(:subscriptions)
        expect(a.macro).to eq :has_many
      end

      it "sets subscriptions class" do
        a = owner_class.reflect_on_association(:subscriptions)
        expect(a.options[:class_name]).to eq 'Susply::Subscription'
      end

      it "sets subscriptions foreign key" do
        a = owner_class.reflect_on_association(:subscriptions)
        expect(a.options[:foreign_key]).to eq 'owner_id'
      end
    end

    describe "sets the has many relationship for payments" do
      it "has many payments" do
        a = owner_class.reflect_on_association(:payments)
        expect(a.macro).to eq :has_many
      end

      it "sets payments class" do
        a = owner_class.reflect_on_association(:payments)
        expect(a.options[:class_name]).to eq 'Susply::Payment'
      end

      it "sets payments foreign key" do
        a = owner_class.reflect_on_association(:payments)
        expect(a.options[:foreign_key]).to eq 'owner_id'
      end
    end


    describe "#active_subscription" do
      it "returns nil when the is no subscrition" do
        o = owner_class.create

        expect(o.active_subscription).to be_nil
      end

      it "returns nil when the is no active subscription" do
        o = owner_class.create
        s = create(:susply_subscription, :inactive, owner: o)

        expect(o.active_subscription).to be_nil
      end

      it "returns the active subscription when presente" do
        o = owner_class.create
        s = create(:susply_subscription, :active, owner: o)

        expect(o.active_subscription).to eq s
      end
    end

    describe "#has_active_subscription?" do
      it "returns true when there is an active subscription" do
        o = owner_class.create
        s = create(:susply_subscription, :active, owner: o)

        expect(o.has_active_subscription?).to eq true
      end

      it "returns false when there is not an active subscription" do
        o = owner_class.create
        s = create(:susply_subscription, :inactive, owner: o)

        expect(o.has_active_subscription?).to eq false
      end
    end

    describe "#most_recentry_deactivated_subscription" do
      it "returns nil when there is no inactive subscription" do
        o = owner_class.create
        s = create(:susply_subscription, :active, owner: o)

        expect(o.most_recently_deactivated_subscription).to be_nil
      end

      it "returns the most recently deactivated usbscription"  do
        o = owner_class.create
        mr = create(:susply_subscription, :inactive, owner: o)
        nr = create(:susply_subscription, :inactive, owner: o, 
                    deactivated_at: Time.zone.now - 5.days)

        expect(o.most_recently_deactivated_subscription).to eq mr
      end
    end
  end
end
