require './pieces.rb'

describe GamePiece do 
  let!(:piece) do
    @piece = GamePiece.new("white", ['d', 5])
  end

  describe "#is_move_straight?" do
    it "returns 1 if new_position is 1 place forward" do
      expect(piece.is_move_straight?(['d', 6])).to eql(1)
    end

    it "returns 4 if new_position is 4 places to the side" do
      expect(piece.is_move_straight?(['h', 5])).to eql(4)
    end

    it "returns false if new_position is diagonal 3 places" do
      expect(piece.is_move_straight?(['g', 8])).to eql(false)
    end

    it "returns false if new_position is diagonal to the bottom left 1 place" do
      expect(piece.is_move_straight?(['c', 4])).to eql(false)
    end
  end

  describe "#is_move_diagonal?" do
    it "returns 1 if new_position is diagonal forward 1 spot" do
      expect(piece.is_move_diagonal?(['e', 6])).to eql(1)
    end

    it "returns 3 if new_position is diagonal forward, left 3 spot" do
      expect(piece.is_move_diagonal?(['a', 8])).to eql(3)
    end

    it "returns 2 if new_position is diagonal backward, left 2 spot" do
      expect(piece.is_move_diagonal?(['b', 3])).to eql(2)
    end

    it "returns 4 if new_position is diagonal backward, right 4 spot" do
      expect(piece.is_move_diagonal?(['h', 1])).to eql(4)
    end

    it "returns false if new_position is straight ahead" do
      expect(piece.is_move_diagonal?(['d', 8])).to eql(false)
    end
  end
end

describe King do
  let!(:king) do
    @king = King.new("white", ['d', 5])
  end

  describe "#make_move" do
    it "returns kings new position on movement of 1 spot forward" do
      expect(king.make_move(['d', 6])).to eql(['d',6])
    end

    it "returns kings new position on movement of 1 spot diagonal behind" do
      expect(king.make_move(['c', 4])).to eql(['c',4])
    end

    it "returns false on movement of more than 1 spot to the side" do
      expect(king.make_move(['g', 5])).to eql(false)
    end
  end
end