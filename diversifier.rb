module Diversifier
  
  require_relative 'diversifier/group'
  require_relative 'diversifier/iteration'
  require_relative 'diversifier/project'

  def self.run
    Project.run
  end

end

Diversifier.run