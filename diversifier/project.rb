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
      create_iteration if viable?
      recalculate_and_save!
    end

    def create_iteration
      next_iteration = self.iterations.create(
        group: Diversifier::Group.new(group_params),
        members: last_iteration.members,
        majority: last_iteration.majority,
        minority: last_iteration.minority,
        previous_popularity: previous_popularity,
        previous_effectiveness: previous_effectiveness
      )
      next_iteration.iterate!
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
        :avg_diversity      => self.iterations.avg(:diversity),
        :avg_effectiveness  => self.iterations.avg(:effectiveness),
        :avg_popularity     => self.iterations.avg(:popularity),
        :avg_group_size     => self.iterations.avg(:members)
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

  end

end