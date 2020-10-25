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

  describe "#clean_input" do
    it "returns an array of cleaned input" do
      expect(game.send(:clean_input, "Rook a3 a6")).to eql(["rook",['a',3],['a',6]])
    end

    it "returns false if invalid row coordinate inputs" do
      expect(game.send(:clean_input, "Rook aa a6")).to eql(false)
    end

    it "returns false if invalid column coordinate inputs" do
      expect(game.send(:clean_input, "Rook a3 56")).to eql(false)
    end

    it "returns false if invalid number of arguments are entered" do
      expect(game.send(:clean_input, "rook a5")).to eql(false)
    end
  end
end