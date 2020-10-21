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

describe Queen do
  let(:queen) do
    @queen = Queen.new("white", ['d', 5])
  end

  describe "#make_move" do
    it "returns new queen position on side movement of 4" do
      expect(queen.make_move(['h', 5])).to eql(['h', 5])
    end

    it "returns new queen position on diagonal movement of 2" do
      expect(queen.make_move(['f', 3])).to eql(['f',3])
    end

    it "returns false if new_position is not in a diagonal or straight line of queen" do
      expect(queen.make_move(['f', 1])).to eql(false)
    end
  end
end

describe Bishop do
  let(:bishop) do
    @bishop = Bishop.new("white", ['d', 5])
  end

  describe "#make_move" do
    it "returns new bishop position on diagonal forward, left move of 3" do
      expect(bishop.make_move(['a', 8])).to eql(['a', 8])
    end

    it "returns new bishop position on diagonal behind left move" do
      expect(bishop.make_move(['a', 2])).to eql(['a', 2])
    end

    it "returns false if move is not a diagonal of current positon" do
      expect(bishop.make_move(['a', 5])).to eql(false)
    end
  end
end

describe Knight do
  let(:knight) do
    @knight = Knight.new("white", ['d', 5])
  end

  describe "#make_move" do
    it "returns the new knight positon on forward knight move" do
      expect(knight.make_move(['c', 3])).to eql(['c', 3])
    end

    it "returns the new knight position on side knight move" do
      expect(knight.make_move(['f',4])).to eql(['f',4])
    end

    it "returns false on invalid move" do
      expect(knight.make_move(['e',5])).to eql(false)
    end
  end
end

describe Rook do 
  let(:rook) do 
    @rook = Rook.new("white", ['d', 5])
  end

  describe "#make_move" do
    it "returns new rook positon on backward move" do
      expect(rook.make_move(['d', 2])).to eql(['d', 2])
    end

    it "returns false if new_positon is a diagonal of current positon" do
      expect(rook.make_move(['e', 4])).to eql(false)
    end

    it "returns false if new_positon not a straight line of current position" do
      expect(rook.make_move(['g', 3])).to eql(false)
    end
  end
end

describe Pawn do
  let(:white_pawn) do
    @white_pawn = Pawn.new("white", ['d', 5])
  end

  let(:black_pawn) do
    @black_pawn = Pawn.new("black", ['d', 5])
  end

  describe "#make_move" do
    #White piece testing
    it "returns new pawn positon on forward move of white piece" do
      expect(white_pawn.make_move(['d', 6])).to eql(['d', 6])
    end

    it "returns new positon on a diagonal forward move of 1 if on overtake for white piece" do
      expect(white_pawn.make_move(['c', 6], true)).to eql(['c', 6])
    end

    it "returns false on backward move of 1 for white piece" do
      expect(white_pawn.make_move(['d', 4])).to eql(false)
    end

    it "returns false on diagonal forward move if not on overtake for white piece" do
      expect(white_pawn.make_move(['e', 6])).to eql(false)
    end

    #Black piece testing
    it "returns new pawn positon on forward move of white piece" do
      expect(black_pawn.make_move(['d', 4])).to eql(['d', 4])
    end

    it "returns new positon on a diagonal forward move of 1 if on overtake for white piece" do
      expect(black_pawn.make_move(['c', 4], true)).to eql(['c', 4])
    end

    it "returns false on backward move of 1 for white piece" do
      expect(black_pawn.make_move(['d', 6])).to eql(false)
    end

    it "returns false on diagonal forward move if not on overtake for white piece" do
      expect(black_pawn.make_move(['e', 4])).to eql(false)
    end
  end
end