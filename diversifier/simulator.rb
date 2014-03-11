module Diversifier

  class Simulator

    require 'table_print'

    attr_accessor :projects
    
    def run
      self.projects ||= []
      print "\r\e[0KSimulating project #{self.projects.count + 1}..."
      self.projects << Project.run
      run unless diverse_projects.count == 100
    end

    def summarize
      puts; puts
      diverse_report = Report.new(diverse_projects, "Diverse Projects")
      homogenous_report = Report.new(homogenous_projects, "Homogenous Projects")

      tp.set Report, Report.attributes
      tp [homogenous_report, diverse_report] 
    end

    def diverse_projects
      projects.select{|p| p.max_diversity > 0}[0..99]
    end

    def homogenous_projects
      projects.select{|p| p.max_diversity == 0}[0..99]
    end

    def report(projs)
      puts "Releases\tMax Members\tMax Diversity\tMax Effectiveness\tMax Popularity"
      projs.each{|project| project.final_report}
    end

    def final_report
      report(diverse_projects)
      report(homogenous_projects)
    end

  end

  class Report

    attr_accessor :projects, :type

    def self.attributes
      [:type, :avg_releases, :avg_members, :avg_effectiveness, :avg_popularity]
    end

    def initialize(projects, type)
      self.projects = projects
      self.type = type
    end

    def avg_releases
      values = self.projects.map(&:total_iterations)
      values.reduce(:+) / values.count
    end

    def avg_members
      values = self.projects.map(&:max_group_size)
      values.reduce(:+) / values.count
    end

    def avg_effectiveness
      values = self.projects.map(&:max_effectiveness)
      values.reduce(:+) / values.count
    end

    def avg_popularity
      values = self.projects.map(&:max_popularity)
      values.reduce(:+) / values.count
    end

  end

end