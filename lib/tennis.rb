require 'state_machine'

class Tennis
  state_machine initial: :not_started do
    event :start_game do
      transition :not_started => :in_progress
    end

    after_transition :not_started => :in_progress, do: :score_changed
    after_transition :deuce => [:advantage_to_a, :advantage_to_b], do: :score_changed
    after_transition [:advantage_to_a, :advantage_to_b] => :deuce, do: :score_changed
    after_transition :advantage_to_a => :won_by_a, do: :score_changed
    after_transition :advantage_to_b => :won_by_b, do: :score_changed

    event :player_a_won do
      transition [:in_progress, :advantage_to_a] => :won_by_a
    end

    event :player_b_won do
      transition [:in_progress, :advantage_to_b] => :won_by_b
    end

    event :reached_deuce do
      transition :in_progress => :deuce
    end

    event :player_a_gained_advantage do
      transition :deuce => :advantage_to_a
    end

    event :player_b_gained_advantage do
      transition :deuce => :advantage_to_b
    end

    event :player_a_reduced_the_advantage do
      transition :advantage_to_b => :deuce
    end

    event :player_b_reduced_the_advantage do
      transition :advantage_to_a => :deuce
    end

    state :not_started do
      def point_to_player_a
        raise_error
      end

      def point_to_player_b
        raise_error
      end

      private

      def raise_error
        raise RuntimeError.new("Game has not started yet")
      end
    end

    state :in_progress do
      def point_to_player_a
        point_to_player(:a)
      end

      def point_to_player_b
        point_to_player(:b)
      end

      def point_to_player(player)
        @scores[player] += 1

        reached_deuce if @scores.values == [ 3, 3 ]

        player_a_won if @scores[:a] == 4
        player_b_won if @scores[:b] == 4

        score_changed
      end

      def score_for_display
        "#{format_score(@scores[:a])}-#{format_score(@scores[:b])}"
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

    state :deuce do
      def point_to_player_a
        # @player_a_score += 1 # I don't think we need this
        player_a_gained_advantage
      end

      def point_to_player_b
        # @player_a_score += 1 # I don't think we need this
        player_b_gained_advantage
      end

      def score_for_display
        "40-40 deuce"
      end
    end

    state :advantage_to_a do
      def point_to_player_a
        player_a_won
      end

      def point_to_player_b
        player_b_reduced_the_advantage
      end

      def score_for_display
        "40-40 advantage A"
      end
    end

    state :advantage_to_b do
      def point_to_player_a
        player_a_reduced_the_advantage
      end

      def point_to_player_b
        player_b_won
      end

      def score_for_display
        "40-40 advantage B"
      end
    end

    state :won_by_a do
      def score_for_display
        "Game to A"
      end
    end

    state :won_by_b do
      def score_for_display
        "Game to B"
      end
    end
  end

  def initialize(scoreboard)
    super()

    @scoreboard = scoreboard
    @scores = { a: 0, b: 0 }
  end

  private

  def score_changed
    @scoreboard.score_changed(score_for_display)
  end
end