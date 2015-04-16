require 'requirements'
require 'system_gateway'

class Checkout do
  class << self
    def branch(branch) do
      commands = []
      commands.push "git fetch"
      commands.push "git checkout #{branch}"
      commands.each do { |command| SystemGateway.perform_with_exit_code(command)}
    end
  end
end
