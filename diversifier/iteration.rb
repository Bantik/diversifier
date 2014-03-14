module Diversifier

  class Iteration

    include Mongoid::Document
    include Mongoid::Timestamps

    MINIMUM_EFFECTIVENESS = 75

    field :effectiveness, type: :integer, default: 75
    field :popularity, type: :integer, default: 0 
    field :members, type: :integer, default: 2
    field :majority, type: :integer, default: 0
    field :minority, type: :integer, default: 0
    field :diversity, type: :float, default: 0.0

    embedded_in :project, inverse_of: :iterations

    attr_accessor :group, :previous_effectiveness, :previous_popularity

    def iterate!
      self.group.resize
      self.majority = self.group.majority
      self.minority = self.group.majority
      self.members = self.group.members
      self.diversity = self.group.diversity
      self.effectiveness = self.group.effectiveness
      self.popularity = recalculate_popularity
      self
    end

    def group
      @group ||= Diversifier::Group.new
    end

    def meets_needs?
      self.effectiveness >= MINIMUM_EFFECTIVENESS
    end

    def recalculate_popularity
      if meets_needs?
        new_value = (self.previous_popularity + 5)
      else
        new_value = (self.previous_popularity - 5)
      end 
      [[new_value, 100].min, 0].max
    end

  end

end