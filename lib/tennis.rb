class Tennis
  def initialize(scoreboard)
    @scoreboard = scoreboard
  end

  def start_game
    @scoreboard.score_changed("0-0")
  end
end