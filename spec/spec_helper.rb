require 'ap'

module TennisSpec
  def self.included(host)
    host.extend(ExampleGroupMethods)

    host.before(:each) do
      @score = :game_not_started
    end
  end

  module ExampleGroupMethods
    def score_is_now(score)
      specify { expect(@score).to be == score }
    end

    def point_to_player(player, &block)
      context "#{player.to_s.upcase}" do
        before(:each) { tennis.send(:"point_to_player_#{player}") }
        class_eval(&block)
      end
    end
  end

  # Self-shunt
  def score_changed(new_score)
    @score = new_score
  end
end

RSpec.configure do |config|
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end
