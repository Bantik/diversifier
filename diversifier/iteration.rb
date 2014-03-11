module Diversifier

  class Iteration

    attr_accessor :group, :group_size, :popularity, :diversity, :effectiveness
    attr_accessor :previous_effectiveness, :previous_popularity

    def self.with(group, effectiveness, popularity)
      iteration = new
      iteration.group = group
      iteration.group_size = group && group.size || 2
      iteration.diversity = group && group.diversity || 0
      iteration.previous_popularity = popularity || 10
      iteration.previous_effectiveness = 75
      iteration
    end

    def group
      @group ||= Diversifier::Group.new
    end

    def effectiveness
      @effectiveness ||= self.group.effectiveness
    end

    def meets_needs?
      effectiveness >= 75
    end

    def percent(value)
      value / 100.0
    end

    def popularity
      if meets_needs?
        new_value = (self.previous_popularity + 5)
      else
        new_value = (self.previous_popularity - 5)
      end 
      @popularity = [[new_value, 100].min, 0].max
    end

  end

end