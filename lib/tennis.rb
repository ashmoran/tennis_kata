class Tennis
  def initialize(scoreboard)
    @scoreboard = scoreboard
    @player_a_score = 0
    @player_b_score = 0
  end

  def start_game
    score_changed
  end

  def point_to_player_a
    @player_a_score += 1
    score_changed
  end

  def point_to_player_b
    @player_b_score += 1
    score_changed
  end

  private

  def score_changed
    @scoreboard.score_changed(score_for_display)
  end

  def score_for_display
    "#{format_score(@player_a_score)}-#{format_score(@player_b_score)}"
  end

  SCORE_FORMATS = {
    0 => 0,
    1 => 15,
    2 => 30,
    3 => 40
  }

  def format_score(score)
    SCORE_FORMATS[score]
  end
end