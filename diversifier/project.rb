module Diversifier
  
  class Project

    include Mongoid::Document

    field :avg_popularity, type: :float, default: 0.0
    field :avg_effectiveness, type: :float, default: 0.0
    field :avg_group_size, type: :float, default: 0.0
    field :avg_diversity, type: :float, default: 0.0

    embeds_many :iterations

    def self.diverse
      where(:avg_diversity.gt => 0)
    end

    def self.homogenous
      where(:avg_diversity => 0)
    end

    def setup
      self.iterations.delete_all
      self.iterations.create(
        members: 2,
        majority: 2,
        minority: 0,
        previous_popularity: 10,
        previous_effectiveness: 75
      )
    end

    def release
      return unless viable?
      next_iteration = self.iterations.create(
        group: Diversifier::Group.new(group_params),
        members: last_iteration.members,
        majority: last_iteration.majority,
        minority: last_iteration.minority,
        previous_popularity: previous_popularity,
        previous_effectiveness: previous_effectiveness
      )
      next_iteration.iterate!
      recalculate_and_save!
    end

    def group_params
      {
        members: last_iteration.members,
        majority: last_iteration.majority,
        minority: last_iteration.minority,
        previous_effectiveness: last_iteration.effectiveness
      }
    end

    def viable?
      last_iteration.members > 0 && previous_effectiveness > 0
    end

    def recalculate_and_save!
      return unless self.iterations.count > 0
      update_attributes(
        :avg_diversity      => max_diversity / total_iterations.to_f,
        :avg_effectiveness  => max_effectiveness / total_iterations.to_f,
        :avg_popularity     => max_popularity / total_iterations.to_f,
        :avg_group_size     => max_group_size / total_iterations.to_f
      )
    end

    def last_group
      last_iteration.try(:group) || Diversifier::Group.new(members: 2, previous_effectiveness: 50)
    end

    def previous_effectiveness
      last_group.try(:effectiveness) || 50
    end

    def previous_popularity
      last_iteration.try(:popularity) || 10
    end

    def last_iteration
      self.iterations.last
    end

    def total_iterations
      @total_iterations ||= self.iterations.count
    end

    def max_group_size
      self.iterations.map(&:members).flatten.max
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

  end

end