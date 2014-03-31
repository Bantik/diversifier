module Diversifier

  class Simulator

    require 'curses'

    Curses.noecho
    Curses.init_screen

    attr_accessor :projects
    
    def self.run!(projects=500, releases = 50)
      (1..projects).to_a.inject([]) do |a, i|
        project = Project.create
        project.setup
        releases.times{ project.release }
        a << project
        summarize
        a
      end
      puts
      summarize
    end

    def self.reset!
      Diversifier::Project.delete_all
    end

    def self.summarize
      homogenous_report = Report.new(Diversifier::Project.homogenous, "Homogenous Projects")
      diverse_report = Report.new(Diversifier::Project.diverse, "Diverse Projects")
      [homogenous_report, diverse_report].each{|report| report.print}
    end

  end

  class Report

    attr_accessor :projects, :type

    def self.attributes
      [:type, :count, :avg_releases, :avg_members, :avg_effectiveness, :avg_popularity]
    end

    def header
      string = []
      padding.each_with_index do |pad_length, i|
        string << sprintf("%-#{pad_length}s", Report.attributes[i].to_s.upcase.gsub('_', ' '))
      end
      string * "\t"
    end

    def initialize(projects, type)
      self.projects = projects
      self.type = type
    end

    def padding
      [20, 15, 15, 15, 19, 15]
    end

    def to_s
      string = []
      padding.each_with_index do |pad_length, i|
        string << sprintf("%-#{pad_length}s", formatted(self.send(Report.attributes[i])))
      end
      string * "\t"
    end

    def index
      self.type == "Homogenous Projects" ? 2 : 3
    end

    def print
      if self.index == 2
        Curses.setpos(0, 0)
        Curses.addstr(header)
        Curses.setpos(1, 0)
        Curses.addstr("-" * (header.length * 1.3).to_i)
      end
      Curses.setpos(index, 0)
      Curses.addstr(to_s)
      Curses.refresh    
    end

    def count
      self.projects.count
    end

    def formatted(value)
      return value if value.to_s == value
      sprintf("%0.1f", value)
    end

    def avg_releases
      return 0 unless self.projects.present?
      self.projects.sum(&:total_iterations) / self.projects.count.to_f
    end

    def avg_members
      return 0 unless self.projects.present?
      self.projects.sum(&:avg_group_size) / self.projects.count.to_f
    end

    def avg_effectiveness
      return 0 unless self.projects.present?
      self.projects.sum(&:avg_effectiveness) / self.projects.count.to_f
    end

    def avg_popularity
      return 0 unless self.projects.present?
      self.projects.sum(&:avg_popularity) / self.projects.count.to_f
    end

  end

end