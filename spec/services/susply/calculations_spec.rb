require 'spec_helper'

module Susply
  describe Calculations do
    let(:start) { Time.zone.now }
    describe ".end_period_calculation" do
      it "returns one year when plan interval is yearly" do
        interval = 'yearly'
        result = Susply::Calculations.end_period_calculation(start, interval)

        expect(result).to eq(start + 1.year)
      end

      it "returns one month when plan interval is monthly" do
        interval = 'monthly'
        result = Susply::Calculations.end_period_calculation(start, interval)

        expect(result).to eq(start + 1.month)
      end
      
      it "returns one month when there is not register interval" do
        interval = 'not-registered-interval'
        result = Susply::Calculations.end_period_calculation(start, interval)

        expect(result).to eq(start + 1.month)
      end
    end
  end
end
