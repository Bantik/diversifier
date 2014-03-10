module Diversifier

  class Group

    attr_accessor :in_group, :out_group, :initial_tolerance, :newcomers, :out_group_newcomers, :in_group_newcomers

    def initialize(args={})
      self.in_group = args[:in_group] || 2
      self.out_group = args[:out_group] || 0
      self.initial_tolerance = args[:tolerance] || 25
      reset
    end

    def reset
      self.in_group = majority
      self.out_group = minority

      self.out_group_newcomers = 0
      self.in_group_newcomers = 0
    end

    def grow

      reset

      if diversity > tolerance
        self.newcomers = 0
        self.in_group -= rand(3)
      else
        self.newcomers = rand(3)
        self.newcomers.times do
          if signaling && rand(2) == 1 || rand(10) == 1
            self.out_group += 1 
            self.out_group_newcomers += 1
          else
            self.in_group += 1
            self.in_group_newcomers += 1
          end
        end
      end 
      self
    end

    def accuracy
      [in_group_accuracy, out_group_accuracy].max
    end

    def in_group_accuracy
      return 0 unless in_group_newcomers > 0
      consensus(in_group_newcomers.to_i) == consensus(in_group) ? 35 : 65
    end

    def out_group_accuracy
      return 0 unless out_group_newcomers > 0
      consensus(out_group_newcomers.to_i) == consensus(out_group) ? 60 : 75
    end

    def consensus(group)
      opinions = (0..group).to_a.inject({}) do |h, i|
        opinion = rand(2)
        h[opinion] ||= 0
        h[opinion] += 1
        h
      end
      opinions.max_by{|i| opinions[i]}.first
    end

    def signaling
      diversity > 10
    end

    def majority
      [in_group, out_group].max
    end

    def minority
      [in_group, out_group].min
    end

    def diversity
      return 0 if minority.zero? || majority.zero?
      (minority / majority.to_f ) * 100
    end

    def size
      in_group + out_group
    end

    def tolerance
      if diversity > 0
        [diversity + 25, 100].min
      else
        self.initial_tolerance
      end
    end

  end

end
