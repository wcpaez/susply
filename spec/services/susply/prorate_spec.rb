require 'spec_helper'

module Susply
  describe Prorate do
    let(:time) {Time.zone.now}

    describe ".call" do
      it "returns 0 when subscription is not active" do
        time = Time.zone.now - 3.days
        subscription = create(:susply_subscription, deactivated_at: time)

        expect(Susply::Prorate.call(subscription)).to be 0
      end

      it "returns the calculated amount for montly" do
        plan = build(:susply_plan, price: 100, interval: 'monthly')
        s = build(:susply_subscription, current_period_start: time - 7.days,
                  plan: plan )

        expect(Susply::Prorate.call(s)).to be 24
      end

      it "returns the calculated amount for yearly" do
        plan = build(:susply_plan, price: 1000, interval: 'yearly')
        s = build(:susply_subscription, current_period_start: time - 304.days,
                  plan: plan )

        expect(Susply::Prorate.call(s)).to be 1000
      end
    end

    describe ".used_days" do
      it "returns the number of days in a month" do
        s = build(:susply_subscription, current_period_start: time - 7.days )

        expect(Susply::Prorate.used_days(s)).to be 7
      end

      it "returns the number of days in a year" do
        s = build(:susply_subscription, current_period_start: time - 102.days )

        expect(Susply::Prorate.used_days(s)).to be 102
      end
    end

    describe ".calculate_used_amount" do
      context "when plan interval is yearly" do
        it "returns the prorate amount with price + 2 months" do
          plan = build(:susply_plan, price: 40, interval: 'yearly')
          used_days = 182
          amount = Susply::Prorate.calculate_used_amount(plan, used_days)

          expect(amount).to be 24
        end

        it "always return an integer value" do
          plan = build(:susply_plan, price: 100, interval: 'yearly')
          used_days = 91
          amount = Susply::Prorate.calculate_used_amount(plan, used_days)

          expect(amount).to be 30
        end
      end

      context "when plan interval is monthly" do
        it "returns the prorate amount based on 30 days use" do
          plan = build(:susply_plan, price: 100, interval: 'monthly')
          used_days = 91
          amount = Susply::Prorate.calculate_used_amount(plan, used_days)

          expect(amount).to be 304
        end

        it "returns the prorate amount based on 30 days use" do
          plan = build(:susply_plan, price: 49, interval: 'monthly')
          used_days = 15
          amount = Susply::Prorate.calculate_used_amount(plan, used_days)

          expect(amount).to be 25
        end

        it "returns the exact amount used" do
          plan = build(:susply_plan, price: 99, interval: 'monthly')
          used_days = 10
          amount = Susply::Prorate.calculate_used_amount(plan, used_days)

          expect(amount).to be 33
        end
      end
    end
  end
end
