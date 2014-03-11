require 'spec_helper'

describe Diversifier::Group do

  describe "#initialize" do

    let(:group) { 
      Diversifier::Group.new(
        in_group: 5,
        out_group: 4,
        tolerance: 50
      )
    }

    it "initializes with in_group size" do
      expect(group.in_group).to eq(5)
    end

    it "initializes with out_group size" do
      expect(group.out_group).to eq(4)
    end

    it "initializes with tolerance" do
      expect(group.initial_tolerance).to eq(50)
    end

  end

  describe "#reset" do

    let(:group) { Diversifier::Group.new }
    
    before do
      group.in_group = 4
      group.out_group = 5
      group.out_group_newcomers = 2
      group.in_group_newcomers = 3
      group.reset
    end

    it "assigns majority to in_group" do
      expect(group.in_group).to eq(5)
    end

    it "assigns minority to out_group" do
      expect(group.out_group).to eq(4)
    end

    it "clears out_group newcomer count" do
      expect(group.out_group_newcomers).to eq(0)
    end

    it "clears in_group newcomer count" do
      expect(group.in_group_newcomers).to eq(0)
    end

  end
  
end