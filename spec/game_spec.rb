require './lib/game.rb'

describe Game do
  let!(:game) do
    @game = Game.new
  end

  describe "#get_valid_move" do
    it "doesn't make invalid moves" do
      allow(game).to receive(:gets).and_return("rook a1 a2", "rook a1 a4", "pawn a2 a3")
      expect(game.get_valid_move).to eql(['pawn',['a',2],['a',3]])
    end

  end

  describe "#get_input" do
    it "returns array of move inputs if user input is valid" do
      allow(game).to receive(:gets).and_return("Queen a3 c5")
      expect(game.get_input).to eql(['queen',['a',3],['c',5]])
    end

    it "prompts user to enter move again if invalid input" do 
      allow(game).to receive(:gets).and_return("wrong input", "Closer format input", "EvenCloser bb a5", "a6 b5", "KiNg D5 c6")
      expect{game.get_input}.to output("White player please enter your move:\nWhite player please enter your move:\nWhite player please enter your move:\nWhite player please enter your move:\nWhite player please enter your move:\n").to_stdout
    end
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