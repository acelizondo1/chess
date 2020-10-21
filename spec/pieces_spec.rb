require './pieces.rb'

describe GamePiece do 
  let!(:piece) do
    @piece = GamePiece.new("white", ['d', 5])
  end

  describe "#is_move_straight?" do
    it "returns true if new_position is 1 place forward" do
      expect(piece.is_move_straight?(['d', 6])).to eql(true)
    end

    it "returns true if new_position is 4 places to the side" do
      expect(piece.is_move_straight?(['h', 5])).to eql(true)
    end

    it "returns false if new_position is diagonal 3 places" do
      expect(piece.is_move_straight?(['g', 8])).to eql(false)
    end

    it "returns false if new_position is diagonal to the bottom left 1 place" do
      expect(piece.is_move_straight?(['c', 4])).to eql(false)
    end
  end
end