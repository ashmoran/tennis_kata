require 'state_machine'

class Tennis
  state_machine initial: :in_progress do
    # event :point_to_player_a do
    #   transition :in_progress => :won_by_a
    # end

    event :player_a_won do
      transition :in_progress => :won_by_a
    end

    # after_transition any => :won_by_a, do: :score_changed

    state :in_progress do
      def score_for_display
        "#{format_score(@player_a_score)}-#{format_score(@player_b_score)}"
      end
    end

    state :won_by_a do
      def score_for_display
        "Game to A"
      end
    end
  end

  def initialize(scoreboard)
    super()

    @scoreboard = scoreboard
    @player_a_score = 0
    @player_b_score = 0
  end

  def start_game
    score_changed
  end

  def point_to_player_a
    @player_a_score += 1
    player_a_won if @player_a_score == 4
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