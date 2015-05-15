require 'spec_helper'

module Susply
  describe Plan, type: :model do
    describe "validations" do
      it "should validate" do
        plan = build(:susply_plan)
        expect(plan).to be_valid
      end

      it "should validates sku presence" do
        plan = build(:susply_plan, sku: nil)
        expect(plan).not_to be_valid
      end

      it "should validates sku uniqueness" do
        p1 = create(:susply_plan, sku: 'plan-du')
        p2 = build(:susply_plan, sku: 'pLan-du')
        expect(p2).not_to be_valid
      end

      it "should validates presence of name" do
        plan = build(:susply_plan, name: nil)
        expect(plan).not_to be_valid
      end

      it "should validates presence of description" do
        plan = build(:susply_plan, description: nil)
        expect(plan).not_to be_valid
      end

      it "should validates price is an integer" do
        plan = build(:susply_plan, price: 12.2)
        expect(plan).not_to be_valid
      end
      
      it "should validates price is equal to 0" do
        plan = build(:susply_plan, price: 0)
        expect(plan).to be_valid
      end

      it "should validates price is less than 0" do
        plan = build(:susply_plan, price: -1)
        expect(plan).not_to be_valid
      end

      it "validates interval on montly or yearly" do
        p1 = build(:susply_plan, interval: "wop")
        p2 = build(:susply_plan, interval: "monthly")
        p3 = build(:susply_plan, interval: "yearly")
        
        expect(p1).not_to be_valid
        expect(p2).to be_valid
        expect(p3).to be_valid
      end

      it "validates highlight inclusion" do
        p1 = build(:susply_plan, highlight: nil)
        p2 = build(:susply_plan, highlight: true)
        p3 = build(:susply_plan, highlight: false)
        
        expect(p1).not_to be_valid
        expect(p2).to be_valid
        expect(p3).to be_valid
      end

      it "validates status inclusion" do
        p1 = build(:susply_plan, active: nil)
        p2 = build(:susply_plan, active: true)
        p3 = build(:susply_plan, active: false)
        
        expect(p1).not_to be_valid
        expect(p2).to be_valid
        expect(p3).to be_valid
      end

      it "validates publishdd inclusion" do
        p1 = build(:susply_plan, published: nil)
        p2 = build(:susply_plan, published: true)
        p3 = build(:susply_plan, published: false)
        
        expect(p1).not_to be_valid
        expect(p2).to be_valid
        expect(p3).to be_valid
      end
    end

    describe ".actives" do
      it "returns only plans where status is true" do
        list = create_list(:susply_plan, 2, active: true)
        not_in_list = create(:susply_plan, active: false)

        expect(Susply::Plan.actives).to match_array list
      end
    end

    describe ".published" do
      it "returns only plans than can be published" do
        list = create_list(:susply_plan, 2, published: true)
        not_in_list = create(:susply_plan, published: false)

        expect(Susply::Plan.published).to match_array list
      end
    end
  end
end
