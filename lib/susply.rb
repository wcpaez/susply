require "susply/engine"
require "decorators"

module Susply
  mattr_accessor :subscription_owner_class
  mattr_accessor :billable_entity

  def self.setup(&block)
    yield self
  end

  #ejm :organizations
  def self.owner_resource
    subscription_owner_class.downcase.pluralize.to_sym
  end
end
