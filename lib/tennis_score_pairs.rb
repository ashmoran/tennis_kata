# I quite liked the look of the way Robie Basak ( https://github.com/basak )
# went about this using tuples in Python to store the state and transitions...
#   https://gist.github.com/4177408
# ...so I had a go in Ruby, without looking at Robie's code in detail first.
# Obviously this could be improved a lot, but I just wanted to have a go at
# making it work. (It passed the contract I extracted from my first solution.)

require_relative 'tennis_score_pairs/scores'

class TennisScorePairs
  # I didn't remember how Robie did this so I ended up with
  # 2 and 3 length arrays, just because for some reason I
  # decided testing array length was a good idea
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