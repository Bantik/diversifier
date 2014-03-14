module Diversifier

  class Group

    include PoroPlus

    attr_accessor :previous_effectiveness
    attr_accessor :majority 
    attr_accessor :minority
    attr_accessor :majority_newcomers
    attr_accessor :minority_newcomers
    attr_accessor :members

    DEFAULT_ACCURACY = 50

    def resize(successful=true)
      successful ? handle_growth : handle_attrition
      self
    end

    def handle_attrition
      rand(3).times do
        if rand(2) == 1
          self.majority -= 1
        else
          self.minority -= 1
        end
      end
    end

    def handle_growth
      return unless rand(4) == 1
      rand(3).times do
        if attracting_diversity?
          self.minority_newcomers += 1
        else
          self.majority_newcomers += 1
        end
      end
    end

    def majority
      @majority ||= 0
    end

    def majority_newcomers
      @majority_newcomers ||= 0
    end

    def minority
      @minority ||= 0
    end

    def minority_newcomers
      @minority_newcomers ||= 0
    end

    def effectiveness
      value = [majority_accuracy, minority_accuracy].compact.max 
      value > 0 && value || self.previous_effectiveness
    end

    def majority_accuracy
      return DEFAULT_ACCURACY unless majority_newcomers.to_i > 0
      newcomers_vote = rand(2)
      oldtimers_vote = rand(2)
      newcomers_vote == oldtimers_vote ? 35 : 65
    end

    def minority_accuracy
      return unless minority_newcomers.to_i > 0
      newcomers_vote = rand(2)
      oldtimers_vote = rand(2)
      newcomers_vote == oldtimers_vote ? 60 : 75
    end

    def signals
      signals = 1
      signals += (diversity / 10.0).to_i
      signals
    end

    def attracting_diversity?
      signals.times{ return true if rand(100) < 3}
      false
    end

    def diversity
      begin
        (self.minority / members.to_f * 100).to_i
      rescue
        0
      end
    end

    def members
      self.majority + self.minority
    end

  end

end
