class TennisScorePairs
  TRANSITIONS = {
    [0,  0]  => [15, 0],
    [15, 0]  => [30, 0],
    [30, 0]  => [40, 0],
    [40, 0]  => :player_a_won
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
    if game_in_progress?
      "#{score[0]}-#{score[1]}"
    else
      "Game to A"
    end
  end

  def game_in_progress?
    @score.is_a?(Array)
  end
end