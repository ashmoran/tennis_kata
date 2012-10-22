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

    describe "trying to score" do
      it "raises an error" do
        pending
        expect {
          tennis.point_to_player_a
        }.to raise_error(KeyError)
      end
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

    context "with no advantages" do
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

              context "A" do
                before(:each) { tennis.point_to_player_a }
                specify { expect(@score).to be == "Game to A" }
              end
            end
          end
        end
      end

      context "B B B B" do
        before(:each) do
          tennis.point_to_player_b
          tennis.point_to_player_b
          tennis.point_to_player_b
          tennis.point_to_player_b
        end

        specify { expect(@score).to be == "Game to B" }
      end
    end

    # This example exists because duplication in the implementation means a single
    # context for deuce (below) is not enough to prove the code works in all situations
    specify "deuce can be reached by either players hitting 40 in either order" do
      3.times do
        tennis.point_to_player_b
        tennis.point_to_player_a
      end

      expect(@score).to be == "40-40 deuce"
    end

    context "deuce" do
      before(:each) do
        3.times do
          tennis.point_to_player_a
          tennis.point_to_player_b
        end
      end

      specify { expect(@score).to be == "40-40 deuce" }

      context "A" do
        before(:each) { tennis.point_to_player_a }
        specify { expect(@score).to be == "40-40 advantage A" }

        context "A" do
          before(:each) { tennis.point_to_player_a }
          specify { expect(@score).to be == "Game to A" }
        end

        context "B" do
          before(:each) { tennis.point_to_player_b }
          specify { expect(@score).to be == "40-40 deuce" }
        end
      end

      context "B" do
        before(:each) { tennis.point_to_player_b }
        specify { expect(@score).to be == "40-40 advantage B" }

        context "B" do
          before(:each) { tennis.point_to_player_b }
          specify { expect(@score).to be == "Game to B" }
        end
      end
    end
  end
end