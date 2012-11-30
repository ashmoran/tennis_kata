require 'spec_helper'

require 'tennis_state_machine'
require_relative 'tennis_contract'

describe TennisStateMachine do
  subject(:tennis) { TennisStateMachine.new(self) }

  it_behaves_like "Tennis"
end