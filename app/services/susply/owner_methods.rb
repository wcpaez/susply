module Susply
  module OwnerMethods
    def self.included(base)
      base.extend ClassMethods
      base.class_eval do
        has_many :subscriptions, class_name: 'Susply::Subscription',
          foreign_key: 'owner_id'  
        has_many :payments, class_name: 'Susply::Payment',
          foreign_key: 'owner_id'  
      end
    end

    module ClassMethods
    end

    def has_active_subscription?
      active_subscription.present?
    end

    def active_subscription
      subscriptions.detect(&:active?)
    end

    def most_recently_deactivated_subscription
      subscriptions.reject(&:active?).max_by(&:deactivated_at)
    end  
  end
end
