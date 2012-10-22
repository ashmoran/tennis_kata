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

  describe "starting the game" do
    specify "score starts at 0-0" do
      tennis.start_game
      expect(@score).to be == "0-0"
    end
  end

  describe "scoring" do
    before(:each) { tennis.start_game }

    context "A" do
      before(:each) { tennis.point_to_player_a }
      specify { expect(@score).to be == "15-0" }

      context "A" do
        before(:each) { tennis.point_to_player_a }
        specify { expect(@score).to be == "30-0" }
      end

      context "B" do
        before(:each) { tennis.point_to_player_b }
        specify { expect(@score).to be == "15-15" }

        context "A" do
          before(:each) { tennis.point_to_player_a }
          specify { expect(@score).to be == "30-15" }

          context "A" do
            before(:each) { tennis.point_to_player_a }
            specify { expect(@score).to be == "40-15" }
          end
        end
      end
    end
  end
end