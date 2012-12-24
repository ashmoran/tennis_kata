require 'spec_helper'

require 'tennis_score_strings'
require_relative 'tennis_contract'

describe TennisScoreStrings do
  subject(:tennis) { TennisScoreStrings.new(self) }

  it_behaves_like "Tennis"
end