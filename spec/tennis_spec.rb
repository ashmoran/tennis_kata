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

  context "game started" do
    it "score starts at 0-0" do
      tennis.start_game
      expect(@score).to be == "0-0"
    end
  end
end