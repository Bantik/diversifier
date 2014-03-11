require 'spec_helper'

describe Diversifier::Group do

  describe "#initialize" do

    let(:group) { 
      Diversifier::Group.new(
        in_group: 5,
        out_group: 4,
        effectiveness: 3
      )
    }

    it "initializes with in_group size" do
      expect(group.in_group).to eq(5)
    end

    it "initializes with out_group size" do
      expect(group.out_group).to eq(4)
    end

    it "initializes with previous_effectiveness" do
      expect(group.previous_effectiveness).to eq(3)
    end

  end

  describe "#reset" do

    let(:group) { Diversifier::Group.new }
    
    before do
      group.in_group = 4
      group.in_group_newcomers = 3
      group.out_group = 5
      group.out_group_newcomers = 3
    end

    it "assigns majority to in_group" do
      expect(group.reset.in_group).to eq(8)
    end

    it "assigns minority to out_group" do
      expect(group.reset.out_group).to eq(7)
    end

    it "clears out_group newcomer count" do
      expect(group.reset.out_group_newcomers).to eq(0)
    end

    it "clears in_group newcomer count" do
      expect(group.reset.in_group_newcomers).to eq(0)
    end

  end
  
  describe "#grow" do

    let(:group) { Diversifier::Group.new }

    it "triggers growth if successful" do
      group.should_receive(:handle_growth)
      group.grow(true)
    end

    it "triggers attrition if unsuccessful" do
      group.should_receive(:handle_attrition)
      group.grow(false)
    end

  end

  describe "#effectiveness" do

    let(:group) { Diversifier::Group.new }

    before do
      group.stub(:in_group_newcomers) { 5 }
      group.stub(:out_group_newcomers) { 0 }
      group.stub(:previous_effectiveness) { 25 }
    end

    it "returns the best accuracy of its newcomers" do
      group.stub(:accuracy) { 25 }
      expect(group.effectiveness).to eq(25)
    end

    it "defaults to its previous effectiveness if no newcomers" do
      group.stub(:accuracy) { nil }
      expect(group.effectiveness).to eq(25)
    end
  
  end

  describe "#signals" do

    let(:group) { Diversifier::Group.new }

    it "defaults to one" do
      group.stub(:diversity) { 0 }
      expect(group.signals).to eq(1)
    end

    it "returns 2 if diversity <= 10" do
      group.stub(:diversity) { 10 }
      expect(group.signals).to eq(2)
    end

    it "returns 9 if diversity >= 90" do
      group.stub(:diversity) { 10 }
      expect(group.signals).to eq(2)
    end

  end

  describe "#majority" do

    let(:group) { Diversifier::Group.new }

    it "returns the larger of two groups" do
      group.stub(:in_group) { 5 }
      group.stub(:out_group) { 10 }
      expect(group.majority).to eq(10)
    end

  end

  describe "#minority" do

    let(:group) { Diversifier::Group.new }

    it "returns the smaller of two groups" do
      group.stub(:in_group) { 5 }
      group.stub(:out_group) { 10 }
      expect(group.minority).to eq(5)
    end

  end

  describe "#diversity" do

    let(:group) { Diversifier::Group.new }

    it "returns 0 if no minority" do
      group.stub(:minority) { 0 }
      expect(group.diversity).to eq(0)
    end

    it "returns the percent of population represented by the minority" do
      group.stub(:minority) { 10 }
      group.stub(:size) { 20 }
      expect(group.diversity).to eq(50)
    end

  end

end