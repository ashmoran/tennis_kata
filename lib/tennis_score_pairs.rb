# I quite liked the look of the way Robie Basak ( https://github.com/basak )
# went about this using tuples in Python to store the state and transitions...
#   https://gist.github.com/4177408
# ...so I had a go in Ruby, without looking at Robie's code in detail first.
# Obviously this could be improved a lot, but I just wanted to have a go at
# making it work. (It passed the contract I extracted from my first solution.)
class TennisScorePairs
  # I didn't remember how Robie did this so I ended up with
  # 2 and 3 length arrays, just because for some reason I
  # decided testing array length was a good idea
  WHEN_A_SCORES = {
    [0,   0]  => [15,  0],
    [0,  15]  => [15, 15],
    [0,  30]  => [15, 30],
    [0,  40]  => [15, 40],

    [15,  0]  => [30,  0],
    [15, 15]  => [30, 15],
    [15, 30]  => [30, 30],
    [15, 40]  => [30, 40],

    [30,  0]  => [40,  0],
    [30, 15]  => [40, 15],
    [30, 30]  => [40, 30],
    [30, 40]  => [40, 40],

    [40,  0]  => [:A, :won],
    [40, 15]  => [:A, :won],
    [40, 30]  => [:A, :won],
    [40, 40]  => [:A, :adv],

    [:A, :adv]  => [:A, :won],
    [:B, :adv]  => [40, 40]
  }

  WHEN_B_SCORES = {
    [0,   0]  => [0,  15],
    [0,  15]  => [0,  30],
    [0,  30]  => [0,  40],
    [0,  40]  => [:B, :won],

    [15,  0]  => [15, 15],
    [15, 15]  => [15, 30],
    [15, 30]  => [15, 40],
    [15, 40]  => [:B, :won],

    [30,  0]  => [30, 15],
    [30, 15]  => [30, 30],
    [30, 30]  => [30, 40],
    [30, 40]  => [:B, :won],

    [40,  0]  => [40, 15],
    [40, 15]  => [40, 30],
    [40, 30]  => [40, 40],
    [40, 40]  => [:B, :adv],

    [:A, :adv]  => [40, 40],
    [:B, :adv]  => [:B, :won]
  }

  def initialize(scoreboard)
    @scoreboard = scoreboard
    @score = [0, 0]
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
    @scoreboard.score_changed(humanize(@score))
  end

  def humanize(score)
    if normal_scoring?
      "#{score[0]}-#{score[1]}" + elaboration(@score)
    elsif advantage?
      "40-40 advantage #{@score.first}"
    else
      "Game to #{@score.first}"
    end
  end

  def elaboration(score)
    if deuce?
      " deuce"
    else
      ""
    end
  end

  def deuce?
    @score == [40, 40]
  end

  def advantage?
    @score.last == :adv
  end

  def normal_scoring?
    @score.map(&:class).uniq. == [Fixnum]
  end
end