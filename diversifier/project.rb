module Diversifier
  
  class Project

    attr_accessor :iterations, :group, :avg_productivity, :popularity

    def self.run
      project = Project.new
      project.iterate(limit: 100)
      project.report
    end

    def initialize
      self.group = Group.new
      start = Diversifier::Iteration.new
      start.group = self.group
      start.productivity = 35
      start.effectiveness = 90
      start.popularity = 10
      self.iterations = [start]
    end

    def popularity
      self.iterations.last && self.iterations.last.popularity || 10
    end

    def iterate(args)
      return if self.iterations.count > args[:limit] || popularity < 1
      self.iterations << Diversifier::Iteration.with(group.grow, current_iteration.effectiveness, current_iteration.popularity)
      iterate(args)
    end

    def current_iteration
      self.iterations.last
    end

    def total_iterations
      self.iterations.count
    end

    def average_productivity
      self.iterations.map(&:productivity).reduce(:+) / total_iterations
    end

    def max_group_size
      self.iterations.map(&:group).map(&:size).flatten.max
    end

    def max_diversity
      self.iterations.map(&:diversity).max
    end

    def max_popularity
      self.iterations.map(&:popularity).max
    end

    def report
      s = ""
      s << "Releases: #{self.iterations.count}\t"
      s << "Max Group Size: #{max_group_size}\t"
      s << "Avg Productivity: #{average_productivity.to_i}\t"
      s << "Max Diversity: #{max_diversity.to_i}\t"
      s << "Max Popularity: #{max_popularity.to_i}\t"
      puts s
    end

  end

end