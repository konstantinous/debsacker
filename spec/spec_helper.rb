require 'debsacker'
require 'rspec/its'

class Debsacker::SystemGateway

  def self.perform(command)
    case command
      when 'git reset --hard', 'git clean -fd'
        puts 'Nice Try, Bro'
      else
        super
    end
  end
end