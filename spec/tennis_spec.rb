require 'spec_helper'

require 'tennis'
require_relative 'tennis_contract'

describe Tennis do
  subject(:tennis) { Tennis.new(self) }

  it_behaves_like "Tennis"
end