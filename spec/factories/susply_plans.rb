FactoryGirl.define do
  factory :susply_plan, :class => 'Susply::Plan' do
    sequence :sku do |n| 
      "basic-plan-#{n}"
    end

    name "Principal basic Plan"
    description "Long price subscription"
    price 1
    interval "monthly"
    highlight false
    active false
    published false
  end
end
