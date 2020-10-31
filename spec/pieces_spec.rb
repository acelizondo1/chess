require './lib/pieces.rb'

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

  describe "#generate_random_move_straight" do
    it "returns a valid move on the board" do
      expect(('a'..'h').include?(piece.send(:generate_rand_move_straight)[0])).to eql(true)
      expect((1..8).include?(piece.send(:generate_rand_move_straight)[1])).to eql(true)
    end

    it "returns a valid move in the limit given in parameters" do
      move = piece.send(:generate_rand_move_straight, 1)
      expect(piece.is_move_straight?(move)).to eql(1)
    end
  end

  describe "#generate_random_move_diagonal" do
    it "returns a valid move on the board" do
      expect(('a'..'h').include?(piece.send(:generate_rand_move_diagonal)[0])).to eql(true)
      expect((1..8).include?(piece.send(:generate_rand_move_diagonal)[1])).to eql(true)
    end

    it "returns a valid move in the limit given in parameters" do
      move = piece.send(:generate_rand_move_diagonal, 1)
      expect(piece.is_move_diagonal?(move)).to eql(1)
    end
  end
end

describe King do
  let!(:king) do
    @king = King.new("white", ['d', 5])
  end

  describe "#is_valid_move?" do
    it "returns kings new position on movement of 1 spot forward" do
      expect(king.is_valid_move?(['d', 6])).to eql(['d',6])
    end

    it "returns kings new position on movement of 1 spot diagonal behind" do
      expect(king.is_valid_move?(['c', 4])).to eql(['c',4])
    end

    it "returns false on movement of more than 1 spot to the side" do
      expect(king.is_valid_move?(['g', 5])).to eql(false)
    end
  end

  describe "#map_path" do
    it "returns an array with one position array insode" do
      expect(king.map_path(['d',6])).to eql([['d',5],['d',6]])
    end
    
    it "returns false if invalid move" do
      expect(king.map_path(['h',8])).to eql(false)
    end
  end
end

describe Queen do
  let(:queen) do
    @queen = Queen.new("white", ['d', 5])
  end

  describe "#is_valid_move?" do
    it "returns new queen position on side movement of 4" do
      expect(queen.is_valid_move?(['h', 5])).to eql(['h', 5])
    end

    it "returns new queen position on diagonal movement of 2" do
      expect(queen.is_valid_move?(['f', 3])).to eql(['f',3])
    end

    it "returns false if new_position is not in a diagonal or straight line of queen" do
      expect(queen.is_valid_move?(['f', 1])).to eql(false)
    end
  end

  describe "#map_path" do
    it "returns an array with each spot in a straight path" do
      expect(queen.map_path(['f',5])).to eql([['d',5],['e',5],['f',5]])
    end

    it "returns an array with each spot traveled in a diagonal path" do
      expect(queen.map_path(['b',7])).to eql([['d',5],['c',6],['b',7]])
    end
  end
end

describe Bishop do
  let(:bishop) do
    @bishop = Bishop.new("white", ['d', 5])
  end

  describe "#is_valid_move?" do
    it "returns new bishop position on diagonal forward, left move of 3" do
      expect(bishop.is_valid_move?(['a', 8])).to eql(['a', 8])
    end

    it "returns new bishop position on diagonal behind left move" do
      expect(bishop.is_valid_move?(['a', 2])).to eql(['a', 2])
    end

    it "returns false if move is not a diagonal of current positon" do
      expect(bishop.is_valid_move?(['a', 5])).to eql(false)
    end
  end

  describe "#map_path" do
    it "returns an array with each spot traveled in a diagonal path" do
      expect(bishop.map_path(['b',7])).to eql([['d',5],['c',6],['b',7]])
    end
  end
end

describe Knight do
  let(:knight) do
    @knight = Knight.new("white", ['d', 5])
  end

  describe "#is_valid_move?" do
    it "returns the new knight positon on forward knight move" do
      expect(knight.is_valid_move?(['c', 3])).to eql(['c', 3])
    end

    it "returns the new knight position on side knight move" do
      expect(knight.is_valid_move?(['f',4])).to eql(['f',4])
    end

    it "returns false on invalid move" do
      expect(knight.is_valid_move?(['e',5])).to eql(false)
    end
  end

  describe "#generate_random_move" do
    it "returns a valid move that is on the board" do
      move = knight.send(:generate_random_move)
      p move
      expect(('a'..'h').include?(move[0])).to eql(true)
      expect((1..8).include?(move[1])).to eql(true)
    end
  end
end

describe Rook do 
  let(:rook) do 
    @rook = Rook.new("white", ['d', 5])
  end

  describe "#is_valid_move?" do
    it "returns new rook positon on backward move" do
      expect(rook.is_valid_move?(['d', 2])).to eql(['d', 2])
    end

    it "returns false if new_positon is a diagonal of current positon" do
      expect(rook.is_valid_move?(['e', 4])).to eql(false)
    end

    it "returns false if new_positon not a straight line of current position" do
      expect(rook.is_valid_move?(['g', 3])).to eql(false)
    end
  end

  describe "#map_path" do
    it "returns an array of the spots traveled to new position" do
      expect(rook.map_path(['d',3])).to eql([['d',5],['d',4],['d',3]])
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

  describe "#is_valid_move?" do
    #White piece testing
    it "returns new pawn positon on forward move of white piece" do
      expect(white_pawn.is_valid_move?(['d', 6])).to eql(['d', 6])
    end

    it "returns new positon on a diagonal forward move of 1 if on overtake for white piece" do
      expect(white_pawn.is_valid_move?(['c', 6], true)).to eql(['c', 6])
    end

    it "returns new position if the move is forward 2 and it's the first move" do
      expect(white_pawn.is_valid_move?(['d', 7])).to eql(['d',7])
    end

    it "returns false on backward move of 1 for white piece" do
      expect(white_pawn.is_valid_move?(['d', 4])).to eql(false)
    end

    it "returns false on diagonal forward move if not on overtake for white piece" do
      expect(white_pawn.is_valid_move?(['e', 6])).to eql(false)
    end

    #Black piece testing
    it "returns new pawn positon on forward move of white piece" do
      expect(black_pawn.is_valid_move?(['d', 4])).to eql(['d', 4])
    end

    it "returns new positon on a diagonal forward move of 1 if on overtake for white piece" do
      expect(black_pawn.is_valid_move?(['c', 4], true)).to eql(['c', 4])
    end

    it "returns false on backward move of 1 for white piece" do
      expect(black_pawn.is_valid_move?(['d', 6])).to eql(false)
    end

    it "returns false on diagonal forward move if not on overtake for white piece" do
      expect(black_pawn.is_valid_move?(['e', 4])).to eql(false)
    end
  end
end