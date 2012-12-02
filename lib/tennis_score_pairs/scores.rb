class Score
  def initialize(player_a_score, player_b_score)
    @player_a_score = player_a_score
    @player_b_score = player_b_score
  end

  def to_s
    "#{@player_a_score}-#{@player_b_score}"
  end

  alias_method :humanize, :to_s

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

  alias_method :humanize, :to_s

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

  alias_method :humanize, :to_s

  def eql?(other)
    other.is_a?(Advantage) && @player == other.player
  end

  def hash
    to_s.hash
  end

  protected

  attr_reader :player
end