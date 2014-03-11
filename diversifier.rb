require 'rubygems'
require 'gosu'
require 'debugger'

module Diversifier
  
  require_relative 'diversifier/group'
  require_relative 'diversifier/iteration'
  require_relative 'diversifier/project'

  def self.run
    simulator = Simulator.new
    print "Modeling projects"
    simulator.run
    simulator.summary
  end

  class Simulator

    attr_accessor :projects
    
    def run
      self.projects ||= []
      print "."
      self.projects << Project.run
      run unless diverse_projects.count == 50
    end

    def summary
      puts
      puts "Type\tAvg Releases\tAvg Members\tAvg Effectiveness\tAvg Popularity"
      puts "Homogenous\t#{avg_releases(homogenous_projects)}\t#{avg_members(homogenous_projects)}\t#{avg_effectiveness(homogenous_projects)}\t#{avg_popularity(homogenous_projects)}"
      puts "Diverse\t#{avg_releases(diverse_projects)}\t#{avg_members(diverse_projects)}\t#{avg_effectiveness(diverse_projects)}\t#{avg_popularity(diverse_projects)}"
    end

    def avg_releases(projs)
      values = projs.map(&:total_iterations)
      values.reduce(:+) / values.count
    end

    def avg_members(projs)
      values = projs.map(&:max_group_size)
      values.reduce(:+) / values.count
    end

    def avg_effectiveness(projs)
      values = projs.map(&:max_effectiveness)
      values.reduce(:+) / values.count
    end

    def avg_popularity(projs)
      values = projs.map(&:max_popularity)
      values.reduce(:+) / values.count
    end

    def final_report
      report(diverse_projects)
      report(homogenous_projects)
    end

    def diverse_projects
      projects.select{|p| p.max_diversity > 0}
    end

    def homogenous_projects
      projects.select{|p| p.max_diversity == 0}
    end

    def report(projs)
      puts "Releases\tMax Members\tMax Diversity\tMax Effectiveness\tMax Popularity"
      projs.each{|project| project.final_report}
    end

  end

end

Diversifier.run