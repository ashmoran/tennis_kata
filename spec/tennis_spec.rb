require 'spec_helper'

require 'tennis'

describe Tennis do
  subject(:tennis) { Tennis.new(self) }

  def score_changed(new_score)
    @score = new_score
  end

  before(:each) do
    @score = :game_not_started
  end

  context "game not started" do
    it "has not broadcast a score" do
      expect(@score).to be == :game_not_started
    end
  end
end