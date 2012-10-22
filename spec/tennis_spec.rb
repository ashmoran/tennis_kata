require 'spec_helper'

require 'tennis'

describe Tennis do
  include TennisSpec

  subject(:tennis) { Tennis.new(self) }

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
    before { tennis.start_game }
    score_is_now "0-0"
  end

  describe "scoring" do
    before(:each) { tennis.start_game }

    context "with no advantages" do
      point_to_player :a do
        score_is_now "15-0"

        point_to_player :a do
          score_is_now "30-0"
        end

        point_to_player :b do
          score_is_now "15-15"

          point_to_player :a do
            score_is_now "30-15"

            point_to_player :a do
              score_is_now "40-15"

              point_to_player :a do
                score_is_now "Game to A"
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

        score_is_now "Game to B"
      end
    end

    # This example exists because duplication in the implementation means a single
    # context for deuce (below) is not enough to prove the code works in all situations
    describe "deuce can be reached by either players hitting 40 in either order" do
      before do
        3.times do
          tennis.point_to_player_b
          tennis.point_to_player_a
        end
      end

      score_is_now "40-40 deuce"
    end

    context "deuce" do
      before(:each) do
        3.times do
          tennis.point_to_player_a
          tennis.point_to_player_b
        end
      end

      score_is_now "40-40 deuce"

      point_to_player :a do
        score_is_now "40-40 advantage A"

        point_to_player :a do
          score_is_now "Game to A"
        end

        point_to_player :b do
          score_is_now "40-40 deuce"
        end
      end

      point_to_player :b do
        score_is_now "40-40 advantage B"

        point_to_player :a do
          score_is_now "40-40 deuce"
        end

        point_to_player :b do
          score_is_now "Game to B"
        end
      end
    end
  end
end