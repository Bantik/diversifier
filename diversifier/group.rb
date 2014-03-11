module Diversifier

  class Group

    attr_accessor :in_group, :out_group, :effectiveness, :previous_effectiveness, :out_group_newcomers, :in_group_newcomers

    def initialize(args={})
      self.in_group = args[:in_group] || 2
      self.out_group = args[:out_group] || 0
      self.previous_effectiveness = args[:effectiveness] || 75
      self.out_group_newcomers = 0
      self.in_group_newcomers = 0
    end

    def reset
      Diversifier::Group.new(
        :in_group => self.in_group + self.in_group_newcomers.to_i,
        :out_group => self.out_group + self.out_group_newcomers.to_i,
        :effectiveness => effectiveness
      )
    end

    def handle_attrition
      rand(3).times do
        if rand(2) == 1
          self.in_group -= 1
        else
          self.out_group -= 1
        end
      end
      self.in_group = [self.in_group, 0].max
      self.out_group = [self.out_group, 0].max
    end

    def handle_growth
      return unless rand(4) == 1
      rand(3).times do
        if attracting_diversity
          self.out_group_newcomers += 1
        else
          self.in_group_newcomers += 1
        end
      end
    end

    def grow(successful=true)
      successful ? handle_growth : handle_attrition
      reset
    end

    def effectiveness
      value = [in_group_accuracy.to_i, out_group_accuracy.to_i].compact.max 
      value > 0 && value || self.previous_effectiveness
    end

    def in_group_accuracy
      return unless in_group_newcomers > 0
      newcomers_vote = rand(2)
      oldtimers_vote = rand(2)
      newcomers_vote == oldtimers_vote ? 35 : 65
    end

    def out_group_accuracy
      return unless out_group_newcomers > 0
      newcomers_vote = rand(2)
      oldtimers_vote = rand(2)
      newcomers_vote == oldtimers_vote ? 60 : 75
    end

    def signals
      signals = 1
      signals += (diversity / 10.0).to_i
      signals
    end

    def attracting_diversity
      signals.times{ return true if rand(100) < 3}
      false
    end

    def majority
      [in_group, out_group].max
    end

    def minority
      [in_group, out_group].min
    end

    def diversity
      begin
        ((minority.abs / size.to_f ) * 100).to_i
      rescue
        0
      end
    end

    def size
      in_group + out_group
    end

  end

end
