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
    @player_a_score += 15
    score_changed
  end

  def point_to_player_b
    @player_b_score += 15
    score_changed
  end

  private

  def score_changed
    @scoreboard.score_changed(score_for_display)
  end

  def score_for_display
    "#{@player_a_score}-#{@player_b_score}"
  end
end