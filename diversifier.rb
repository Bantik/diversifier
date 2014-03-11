require 'rubygems'
require 'gosu'
require 'debugger'

module Diversifier
  
  require_relative 'diversifier/group'
  require_relative 'diversifier/iteration'
  require_relative 'diversifier/project'
  require_relative 'diversifier/simulator'

  def self.run
    simulator = Simulator.new
    print "Modeling projects"
    simulator.run
    simulator.summarize
  end

end

unless ENV['RACK_ENV'] == "test"
  Diversifier.run
end