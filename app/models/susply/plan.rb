module Susply
  class Plan < ActiveRecord::Base
    validates_presence_of :sku, :name, :description
    validates_uniqueness_of :sku, case_sensitive: false
    validates :price, numericality: { only_integer: true, 
                                      greater_than_or_equal_to: 0 }

    validates :interval, inclusion: { in: ['monthly', 'yearly'] }
    validates :highlight, inclusion: { in: [true, false] }
    validates :active, inclusion: { in: [true, false] }
    validates :published, inclusion: { in: [true, false] }

    scope :active, -> { where(active: true)}
    scope :published, -> { where(published: true)}
  end
end
