require './lib/game.rb'

describe Game do
  let!(:game) do
    @game = Game.new
  end

  describe "#input_in_range?" do
    it "should return true if all inputs are in board range" do
      expect(game.send(:input_in_range?, "pawn", ['a', 2], ['a', 3])).to eql(true)
    end

    it "returns false if invalid entries" do
      expect(game.send(:input_in_range?, "test", ['a', 2], ['a', 3])).to eql(false)
    end
  end

end