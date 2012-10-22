require 'spec_helper'

require 'tennis'

describe Tennis do
  include TennisSpec

  subject(:tennis) { Tennis.new(self) }

  def score_changed(new_score)
    @scores << new_score
  end

  before(:each) do
    @scores = [ ]
  end

  specification_dsl :tennis do
    for_context :game_not_started do
      nothing
    end

    for_context :game_started do
      tennis.start_game
    end

    for_context :point_to_player do |player|
      player == :a ? tennis.point_to_player_a : tennis.point_to_player_b
    end

    # Only wrote this one to see if `points_scored :b, :b, :b, :b` would work
    for_context :points_scored do |*players|
      players.each do |player|
        player == :a ? tennis.point_to_player_a : tennis.point_to_player_b
      end
    end

    for_context :deuce do
      3.times do
        tennis.point_to_player_a
        tennis.point_to_player_b
      end
    end

    to_expect :score_is_now do |expected_score|
      expect(@scores.last).to be == expected_score
      # I don't like the next line but I put it in purely to prove we can
      # easily add a check for the same score being sent more than once
      expect(@scores.last).to_not be == @scores[-2]
    end

    game_not_started do
      it "is not ready for players to score points" do
        expect { tennis.point_to_player_a }.to raise_error(RuntimeError, "Game has not started yet")
        expect { tennis.point_to_player_b }.to raise_error(RuntimeError, "Game has not started yet")
      end
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

      points_scored :b, :b, :b, :b do
        score_is_now "Game to B"
      end
    end

    deuce do
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