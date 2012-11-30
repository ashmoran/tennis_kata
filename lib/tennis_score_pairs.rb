class TennisScorePairs
  TRANSITIONS = {
    [0,  0]  => [15, 0],
    [15, 0]  => [30, 0],
    [30, 0]  => [40, 0]
  }

  def initialize(scoreboard)
    @scoreboard = scoreboard
    @score = [0, 0]
  end

  def start_game
    score_changed
  end

  def point_to_player_a
    @score = TRANSITIONS[@score]
    score_changed
  end

  def point_to_player_b

  end

  private

  def score_changed
    @scoreboard.score_changed(humanize(@score))
  end

  def humanize(score)
    "#{score[0]}-#{score[1]}"
  end
end