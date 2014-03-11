module Diversifier
  
  class Project

    attr_accessor :iterations, :group, :popularity

    def self.run
      project = Project.new
      project.iterate(limit: 100)
      project.iteration_report
      project.final_report
    end

    def initialize
      self.group = Group.new
      start = Diversifier::Iteration.new
      start.group = self.group
      start.previous_effectiveness = 75
      start.previous_popularity = 10
      self.iterations = [start]
    end

    def popularity
      current_iteration.popularity || 10
    end

    def iterate(args)
      return if self.iterations.count > args[:limit] || popularity < 10 || current_iteration.group.size < 1
      self.iterations << Diversifier::Iteration.with(
        group.grow(current_iteration.meets_needs?),
        current_iteration.effectiveness,
        current_iteration.popularity
      )
      iterate(args)
    end

    def current_iteration
      self.iterations.last
    end

    def total_iterations
      self.iterations.count
    end

    def max_group_size
      self.iterations.map(&:group).map(&:size).flatten.max
    end

    def max_diversity
      self.iterations.map(&:diversity).compact.max
    end

    def max_popularity
      self.iterations.map(&:popularity).compact.max
    end

    def max_effectiveness
      self.iterations.map(&:effectiveness).compact.max
    end

    def iteration_report
      puts "Iteration\tMembers\tDiversity\tEffectiveness\tPopularity"
      self.iterations.each_with_index do |iteration, i|
        s = ""
        s << "#{i+1}\t"
        s << "#{iteration.group.size}\t"
        s << "#{iteration.diversity.to_i}\t"
        s << "#{iteration.effectiveness.to_i}\t"
        s << "#{iteration.popularity.to_i}\t"
        puts s
      end
    end

    def final_report
      s = ""
      s << "Releases: #{self.iterations.count}\t"
      s << "Max Group Size: #{max_group_size}\t"
      s << "Max Diversity: #{max_diversity.to_i}\t"
      s << "Max Effectiveness: #{max_effectiveness.to_i}\t"
      s << "Max Popularity: #{max_popularity.to_i}\t"
      puts s
    end

  end

end