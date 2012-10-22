require 'ap'

module TennisSpec
  def self.included(host)
    host.extend(ExampleGroupMethods)

    host.before(:each) do
      @score = :game_not_started
    end
  end

  module ExampleGroupMethods
    def for_context(name, &context_definition)
      singleton_class.send(:define_method, name) do |*args, &specification_body|
        context(name) do
          before(:each) do
            instance_exec(*args, &context_definition)
          end
          class_eval(&specification_body)
        end
      end
    end

    def to_expect(name, &expectation_definition)
      singleton_class.send(:define_method, name) do |*args|
        specify {
          instance_exec(*args, &expectation_definition)
        }
      end
    end
  end

  # Self-shunt
  def score_changed(new_score)
    @score = new_score
  end

  def nothing
    # NOOP
  end
end

RSpec.configure do |config|
  config.filter_run(focus: true)
  config.run_all_when_everything_filtered = true
end
