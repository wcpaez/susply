require 'spec_helper'

module Susply
  describe Payment, type: :model do
    it "shoulda validate" do
      payment = build(:susply_payment)
      expect(payment).to be_valid
    end

    it "belogs to owner" do
      a = Susply::Payment.reflect_on_association(:owner)
      expect(a.macro).to eq :belongs_to
    end

    it "sets to owner the class on susply initializer" do
      a = Susply::Payment.reflect_on_association(:owner)
      expect(a.options[:class_name]).to eq Susply.subscription_owner_class
    end

    it "belongs to plan" do
      a = Susply::Payment.reflect_on_association(:plan)
      expect(a.macro).to eq :belongs_to
    end

    it "sets the plan class on susply" do
      a = Susply::Payment.reflect_on_association(:plan)
      expect(a.options[:class_name]).to eq 'Susply::Plan'
    end

    it "belongs to subscription" do
      a = Susply::Payment.reflect_on_association(:subscription)
      expect(a.macro).to eq :belongs_to
    end

    it "sets the subscription class on susply" do
      a = Susply::Payment.reflect_on_association(:subscription)
      expect(a.options[:class_name]).to eq 'Susply::Subscription'
    end

    it "validates presence of owner_id" do
      payment = build(:susply_payment, owner_id: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of plan_id" do
      payment = build(:susply_payment, plan_id: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of subscription_id" do
      payment = build(:susply_payment, subscription_id: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of period_start" do
      payment = build(:susply_payment, period_start: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of period_end" do
      payment = build(:susply_payment, period_end: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of status" do
      payment = build(:susply_payment, status: nil)
      expect(payment).not_to be_valid
    end

    it "validates presence of amount" do
      payment = build(:susply_payment, amount: nil)
      expect(payment).not_to be_valid
    end

    it "should validates amount is an integer" do
      payment = build(:susply_payment, amount: 12.2)
      expect(payment).not_to be_valid
    end

    it "should validates amount equal to 0" do
      payment = build(:susply_payment, amount: 0)
      expect(payment).to be_valid
    end

    it "should validates amount greater to 0" do
      payment = build(:susply_payment, amount: 10)
      expect(payment).to be_valid
    end


  end
end
