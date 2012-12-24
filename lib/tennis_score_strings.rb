# I wrote this implementation in about 15 minutes after I realised the
# value object system in TennisScorePairs is over-engineering. The only
# "behaviour" a score has is to turn itself into a string (unless you
# consider generating hashcodes "behaviour").
#
# This version still has the duplication, but then it has half the lines
# of code.
class TennisScoreStrings
  GAME_NOT_STARTED = "<Game not started>"
  def GAME_NOT_STARTED.to_s
    raise RuntimeError.new("Game has not started yet")
  end

  WHEN_A_SCORES = {
    GAME_NOT_STARTED    => GAME_NOT_STARTED,

    "0-0"               => "15-0",
    "0-15"              => "15-15",
    "0-30"              => "15-30",
    "0-40"              => "15-40",

    "15-0"              => "30-0",
    "15-15"             => "30-15",
    "15-30"             => "30-30",
    "15-40"             => "30-40",

    "30-0"              => "40-0",
    "30-15"             => "40-15",
    "30-30"             => "40-30",
    "30-40"             => "40-40 deuce",

    "40-0"              => "Game to A",
    "40-15"             => "Game to A",
    "40-30"             => "Game to A",
    "40-40 deuce"       => "40-40 advantage A",

    "40-40 advantage A" => "Game to A",
    "40-40 advantage B" => "40-40 deuce"
  }

  WHEN_B_SCORES = {
    GAME_NOT_STARTED    => GAME_NOT_STARTED,

    "0-0"               => "0-15",
    "0-15"              => "0-30",
    "0-30"              => "0-40",
    "0-40"              => "Game to B",

    "15-0"              => "15-15",
    "15-15"             => "15-30",
    "15-30"             => "15-40",
    "15-40"             => "Game to B",

    "30-0"              => "30-15",
    "30-15"             => "30-30",
    "30-30"             => "30-40",
    "30-40"             => "Game to B",

    "40-0"              => "40-15",
    "40-15"             => "40-30",
    "40-30"             => "40-40 deuce",
    "40-40 deuce"       => "40-40 advantage B",

    "40-40 advantage A" => "40-40 deuce",
    "40-40 advantage B" => "Game to B"
  }

  def initialize(scoreboard)
    @scoreboard = scoreboard
    @score = GAME_NOT_STARTED
  end

  def start_game
    change_score_to("0-0")
  end

  def point_to_player_a
    change_score_to(WHEN_A_SCORES[@score])
  end

  def point_to_player_b
    change_score_to(WHEN_B_SCORES[@score])
  end

  private

  def change_score_to(new_score)
    @score = new_score
    @scoreboard.score_changed(@score.to_s)
  end
end
