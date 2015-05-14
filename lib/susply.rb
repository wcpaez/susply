require "susply/engine"

module Susply
  mattr_accessor :owner_class

  def self.setup(&block)
    yield self
  end
end
