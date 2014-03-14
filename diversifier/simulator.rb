module Diversifier

  class Simulator

    require 'table_print'

    attr_accessor :projects
    
    def self.run!(projects=500, releases = 50)
      (1..projects).to_a.inject([]) do |a, i|
        project = Project.create
        project.setup
        releases.times{ project.release }
        a << project
      end
      summarize
    end

    def self.reset!
      Diversifier::Project.delete_all
    end

    def self.summarize
      homogenous_report = Report.new(Diversifier::Project.homogenous, "Homogenous Projects")
      diverse_report = Report.new(Diversifier::Project.diverse, "Diverse Projects")
      tp.set Report, Report.attributes
      tp [homogenous_report, diverse_report] 
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
      return 0 unless self.projects.present?
      self.projects.sum(&:total_iterations) / self.projects.count.to_f
    end

    def avg_members
      return 0 unless self.projects.present?
      self.projects.sum(&:max_group_size) / self.projects.count.to_f
    end

    def avg_effectiveness
      return 0 unless self.projects.present?
      self.projects.sum(&:max_effectiveness) / self.projects.count.to_f
    end

    def avg_popularity
      return 0 unless self.projects.present?
      self.projects.sum(&:max_popularity) / self.projects.count.to_f
    end

  end

end