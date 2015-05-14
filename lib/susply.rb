require "susply/engine"

module Susply
  mattr_accessor :subscription_owner_class

  def self.setup(&block)
    yield self
  end
end
