require 'spec_helper'

require 'tennis_score_pairs'
require_relative 'tennis_contract'

describe TennisScorePairs do
  subject(:tennis) { TennisScorePairs.new(self) }

  it_behaves_like "Tennis"
end