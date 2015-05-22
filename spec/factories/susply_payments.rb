FactoryGirl.define do
  factory :susply_payment, :class => 'Susply::Payment' do
    owner_id 1
    plan_id 1
    subscription_id 1
    amount 1
    period_start "2015-05-21 17:26:35"
    period_end "2015-05-21 17:26:35"
    status "generated"
    invoice "MyString"
    generated_type "plan_renovation"
  end
end
