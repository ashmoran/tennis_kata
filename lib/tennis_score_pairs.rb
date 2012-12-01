class TennisScorePairs
  TRANSITIONS = {
    [0,   0]  => [15,  0],

    [15,  0]  => [30,  0],
    [0,  15]  => [15, 15],

    [30,  0]  => [40,  0],
    [15, 15]  => [30, 15],
    [0,  30]  => [15, 30],

    [40,  0]  => [:A, :won, :B],
    [30, 15]  => [40, 15],
    [15, 30]  => [30, 30],
    [0,  40]  => [15, 40],

    [40, 15]  => [:A, :won, :B],
    [30, 30]  => [40, 30],
    [15, 40]  => [30, 40],

    [40, 30]  => [:A, :won, :B],
    [30, 40]  => [40, 40],

    [40, 40]  => [:A, :adv, :B],

    [:A, :adv, :B]  => [:A, :won, :B],
    [:B, :adv, :A]  => [40, 40]
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
    @score = TRANSITIONS[@score.reverse].reverse
    score_changed
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
    @score[1] == :adv
  end

  def normal_scoring?
    @score.length == 2
  end
end