require 'spec_helper'

require 'tennis'

describe Tennis do
  include TennisSpec

  subject(:tennis) { Tennis.new(self) }

  game_not_started do
    it "is not ready for players to score points" do
      expect { tennis.point_to_player_a }.to raise_error(RuntimeError, "Game has not started yet")
      expect { tennis.point_to_player_b }.to raise_error(RuntimeError, "Game has not started yet")
    end
  end

  game_started do
    score_is_now "0-0"

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