module Susply
  class Payment < ActiveRecord::Base
    belongs_to :owner, class_name: Susply.subscription_owner_class
    belongs_to :plan, class_name: 'Susply::Plan' 
    belongs_to :subscription, class_name: 'Susply::Subscription' 

    validates_presence_of :owner_id, :plan_id, :subscription_id,
      :period_start, :period_end, :amount, :status

    validates :amount, numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }

    validates_inclusion_of :generated_type,
      in: %w(plan_renovation plan_change plan_close)

    validates_inclusion_of :status,
      in: %w(generated paid exonerated refunded) 
  end
end
