module Diversifier

  class Iteration

    attr_accessor :group, :popularity, :productivity, :effectiveness

    def self.with(group, effectiveness, popularity)
      iteration = new
      iteration.group = group
      iteration.popularity = popularity
      iteration.effectiveness = effectiveness
      iteration
    end

    def diversity
      self.group.diversity
    end

    def productivity
      productive_hours / total_hours.to_f * 100
    end

    def productive_hours
      total_hours * (success ? 1 : percent(group.accuracy))
    end

    def total_hours
      self.group.size * 2
    end

    def success
      @success ||= group.accuracy >= rand(100)
    end

    def effectiveness
      new_value = @effectiveness + (success ? 10 : -5)
      @effectiveness = [[new_value, 100].min, 0].max
    end

    def meets_needs?
      effectiveness >= 70
    end

    def percent(value)
      value / 100.0
    end

    def popularity
      if meets_needs?
        new_value = @popularity / percent(effectiveness)
      else
        new_value = (@popularity - (@popularity * percent(effectiveness)))
      end 
      @popularity = [[new_value, 100].min, 0].max
    end

  end

end