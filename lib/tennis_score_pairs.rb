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
    @score = Score.new(0, 0)
    extend GameNotStarted
  end

  def start_game
    extend GameStarted
    score_changed
  end

  module GameNotStarted
    def point_to_player_a
      raise RuntimeError.new("Game has not started yet")
    end

    def point_to_player_b
      raise RuntimeError.new("Game has not started yet")
    end
  end

  module GameStarted
    def point_to_player_a
      @score = WHEN_A_SCORES[@score]
      score_changed
    end

    def point_to_player_b
      @score = WHEN_B_SCORES[@score]
      score_changed
    end
  end

  private

  def score_changed
    @scoreboard.score_changed(@score.to_s)
  end
end