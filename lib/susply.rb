require "susply/engine"
require "decorators"

module Susply
  mattr_accessor :subscription_owner_class

  def self.setup(&block)
    yield self
  end
end
