FactoryGirl.define do
  factory :susply_subscription, :class => 'Susply::Subscription' do
    trait :inactive do
      deactivated_at Time.zone.now
    end

    trait :active do
      deactivated_at nil
    end

    owner_id 1
    plan_id 1
    start "2015-05-13 13:01:24"
    current_period_start "2015-05-13 13:01:24"
    current_period_end "2015-05-13 13:01:24"
    quantity 1
    deactivated_at nil
  end
end
