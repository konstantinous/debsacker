require 'debsacker/system_gateway'

module Debsacker
  class Checkout
    class << self
      def branch(branch)
        SystemGateway.perform_with_exit_code('git fetch')
        SystemGateway.perform_with_exit_code("git checkout #{ branch }")
      end
    end
  end
end