# I quite liked the look of the way Robie Basak ( https://github.com/basak )
# went about this using tuples in Python to store the state and transitions...
#   https://gist.github.com/4177408
# ...so I had a go in Ruby, without looking at Robie's code in detail first.
#
# This is the second major phase of my attempt at this kata. I discovered that
# by making the scores into first-class value objects it's possible to remove
# all conditional logic from this code!

require_relative 'tennis_score_pairs/scores'

class TennisScorePairs
  # Robie used a "double-reverse" trick to remove the duplication
  # in the state transitions. I introduced the duplication on purpose
  # to help refactor to this logicless solution. I could remove it
  # again (by implementing #reverse on all the score objects), but
  # it would make the overall code longer, and I suspect harder to read.
  # I prefer this textual duplication as it's so easy to verify by
  # inspection that it's correct, and Tennis scoring never changes anyway.
  WHEN_A_SCORES = {
    GameNotStarted.new  => GameNotStarted.new,

    Score.new(0, 0)     => Score.new(15, 0),
    Score.new(0, 15)    => Score.new(15, 15),
    Score.new(0, 30)    => Score.new(15, 30),
    Score.new(0, 40)    => Score.new(15, 40),

    Score.new(15, 0)    => Score.new(30, 0),
    Score.new(15, 15)   => Score.new(30, 15),
    Score.new(15, 30)   => Score.new(30, 30),
    Score.new(15, 40)   => Score.new(30, 40),

    Score.new(30, 0)    => Score.new(40, 0),
    Score.new(30, 15)   => Score.new(40, 15),
    Score.new(30, 30)   => Score.new(40, 30),
    Score.new(30, 40)   => Deuce.new,

    Score.new(40, 0)    => WonBy.new("A"),
    Score.new(40, 15)   => WonBy.new("A"),
    Score.new(40, 30)   => WonBy.new("A"),
    Deuce.new           => Advantage.new("A"),

    Advantage.new("A")  => WonBy.new("A"),
    Advantage.new("B")  => Deuce.new
  }

  WHEN_B_SCORES = {
    GameNotStarted.new  => GameNotStarted.new,

    Score.new(0, 0)     => Score.new(0, 15),
    Score.new(0, 15)    => Score.new(0, 30),
    Score.new(0, 30)    => Score.new(0, 40),
    Score.new(0, 40)    => WonBy.new("B"),

    Score.new(15, 0)    => Score.new(15, 15),
    Score.new(15, 15)   => Score.new(15, 30),
    Score.new(15, 30)   => Score.new(15, 40),
    Score.new(15, 40)   => WonBy.new("B"),

    Score.new(30, 0)    => Score.new(30, 15),
    Score.new(30, 15)   => Score.new(30, 30),
    Score.new(30, 30)   => Score.new(30, 40),
    Score.new(30, 40)   => WonBy.new("B"),

    Score.new(40, 0)    => Score.new(40, 15),
    Score.new(40, 15)   => Score.new(40, 30),
    Score.new(40, 30)   => Deuce.new,
    Deuce.new           => Advantage.new("B"),

    Advantage.new("A")  => Deuce.new,
    Advantage.new("B")  => WonBy.new("B")
  }

  def initialize(scoreboard)
    @scoreboard = scoreboard
    @score = GameNotStarted.new
  end

  def start_game
    change_score_to(Score.new(0, 0))
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