# Objects that play the "Score" role have only two responsibities:
# * They must be able to turn themselves into strings (for the human UI)
# * They must be able to identify each other in a Hash (for score transitions)

# These classes are the result of moving conditional logic from out of the
# original TennisScorePairs code. This makes the code longer (as we have to
# name everything now, and we can no longer rely on the built-in hash semantics
# for Arrays) but means there is no conditional logic anywhere in the behaviour
# of the app (woop!).

class GameNotStarted
  def to_s
    raise RuntimeError.new("Game has not started yet")
  end

  def eql?(other)
    other.is_a?(GameNotStarted)
  end

  def hash
    "GameNotStarted".hash
  end
end

class Score
  def initialize(player_a_score, player_b_score)
    @player_a_score = player_a_score
    @player_b_score = player_b_score
  end

  def to_s
    "#{@player_a_score}-#{@player_b_score}"
  end

  def eql?(other)
    @player_a_score == other.player_a_score && @player_b_score == other.player_b_score
  end

  def hash
    to_s.hash
  end

  protected

  attr_reader :player_a_score, :player_b_score
end

class Deuce
  def to_s
    "40-40 deuce"
  end

  def eql?(other)
    other.is_a?(Deuce)
  end

  def hash
    to_s.hash
  end
end

class Advantage
  def initialize(player)
    @player = player
  end

  def to_s
    "40-40 advantage #{@player}"
  end

  def eql?(other)
    other.is_a?(Advantage) && @player == other.player
  end

  def hash
    to_s.hash
  end

  protected

  attr_reader :player
end

class WonBy
  def initialize(player)
    @player = player
  end

  def to_s
    "Game to #{@player}"
  end

  def eql?(other)
    other.is_a?(WonBy) && @player == other.player
  end

  def hash
    to_s.hash
  end

  protected

  attr_reader :player
end