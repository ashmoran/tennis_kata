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

  SCORE_TRANSITIONS = {
    GAME_NOT_STARTED    => { a: GAME_NOT_STARTED,     b: GAME_NOT_STARTED },

    "0-0"               => { a: "15-0",               b: "0-15" },
    "0-15"              => { a: "15-15",              b: "0-30" },
    "0-30"              => { a: "15-30",              b: "0-40" },
    "0-40"              => { a: "15-40",              b: "Game to B" },

    "15-0"              => { a: "30-0",               b: "15-15" },
    "15-15"             => { a: "30-15",              b: "15-30" },
    "15-30"             => { a: "30-30",              b: "15-40" },
    "15-40"             => { a: "30-40",              b: "Game to B" },

    "30-0"              => { a: "40-0",               b: "30-15" },
    "30-15"             => { a: "40-15",              b: "30-30" },
    "30-30"             => { a: "40-30",              b: "30-40" },
    "30-40"             => { a: "40-40 deuce",        b: "Game to B" },

    "40-0"              => { a: "Game to A",          b: "40-15" },
    "40-15"             => { a: "Game to A",          b: "40-30" },
    "40-30"             => { a: "Game to A",          b: "40-40 deuce" },
    "40-40 deuce"       => { a: "40-40 advantage A",  b: "40-40 advantage B" },

    "40-40 advantage A" => { a: "Game to A",          b: "40-40 deuce" },
    "40-40 advantage B" => { a: "40-40 deuce",        b: "Game to B" }
  }

  def initialize(scoreboard)
    @scoreboard = scoreboard
    @score = GAME_NOT_STARTED
  end

  def start_game
    change_score_to("0-0")
  end

  def point_to_player_a
    change_score_to(SCORE_TRANSITIONS[@score][:a])
  end

  def point_to_player_b
    change_score_to(SCORE_TRANSITIONS[@score][:b])
  end

  private

  def change_score_to(new_score)
    @score = new_score
    @scoreboard.score_changed(@score.to_s)
  end
end
