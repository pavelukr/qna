require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { belong_to :votable }
end
