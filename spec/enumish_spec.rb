# frozen_string_literal: true

require "spec_helper"

RSpec.describe Enumish do
  before(:all) do
    Temping.create :dummy do
      include ::Enumish

      with_columns do |t|
        t.string :short
      end
    end

    Dummy.create! short: "friendly"
    Dummy.create! short: "jackass"
  end

  let(:friendly) { Dummy.where(short: "friendly").first }
  let(:jackass)  { Dummy.where(short: "jackass").first }

  describe ".<enum_value>" do
    before { friendly && jackass }

    it "returns the correct Enumish row", :focus do
      expect(Dummy.friendly.id).to eq friendly.id
      expect(Dummy.jackass.id).to eq jackass.id
    end
  end

  describe "#<enum_value>?" do
    it "returns true when given the correct row" do
      expect(friendly.friendly?).to eq true
      expect(jackass.jackass?).to eq true
    end

    it "returns false when not given the correct row" do
      expect(jackass.friendly?).to eq false
      expect(friendly.jackass?).to eq false
    end
  end

  describe "#to_sym" do
    it "returns a Symbol representation" do
      expect(friendly.to_sym).to eq :friendly
    end
  end

  describe "#to_s" do
    it "returns a String representation" do
      expect(friendly.to_s).to eq "friendly"
    end
  end
end
