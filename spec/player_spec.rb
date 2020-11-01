require './lib/player.rb'

describe Player do
  let(:white_player) do
    @white_player = Player.new("white")
  end

  describe "#initialize" do
    it "creates an array of white starting pieces storing them in active_pieces" do
      expect(white_player.active_pieces["rook"][0]).to be_kind_of(Rook)
      expect(white_player.color).to eql("white")
      expect(white_player.active_pieces["queen"][0]).to be_kind_of(Queen)
    end
  end

  describe "#make_move" do
    it "updates positon for piece" do
      expect(white_player.make_move("knight", ['b',1], ['c',3])).to eql(['c',3])
    end

    it "returns false if piece cannot be found" do
      expect(white_player.make_move("pawn", ['d',5], ['d',6])).to eql(false)
    end
  end

  describe "#is_valid_move?" do
    it "returns the destination of the moved piece if valid move" do
      expect(white_player.is_valid_move?("rook", ['h', 1], ['h', 5])).to eql(['h',5])
    end

    it "returns false if invalid move is requested" do
      expect(white_player.is_valid_move?("pawn", ['b',2], ['b', 5])).to eql(false)
    end

    it "returns false if destination contains another white_player piece" do
      white_player.make_move("pawn", ['a',2], ['a',3])
      expect(white_player.is_valid_move?("rook", ['a',1], ['a',3])).to eql(false)
    end

    it "returns false if piece is not active" do
      piece = ['a',2]
      white_player.eliminate_piece(piece)
      expect(white_player.is_valid_move?("pawn", ['a',2], ['a',3])).to eql(false)
    end
  end

  describe "#eliminate_piece" do
    it "removes object from active_pieces" do
      pawn_to_eliminate = ['d',2]
      white_player.eliminate_piece(pawn_to_eliminate)
      expect(white_player.active_pieces.include?(pawn_to_eliminate)).to eql(false)
    end

    it "does nothing if the object is not an active piece" do
      pawn_to_eliminate = ['d',2]
      white_player.eliminate_piece(pawn_to_eliminate)
      expect{white_player.eliminate_piece(pawn_to_eliminate)}.to_not change{white_player.active_pieces}
    end

    it "returns true if pawn is overtaking and the position is forward left" do
      expect(white_player.is_valid_move?('pawn',['e',2],['d',3],true)).to eql(['d',3])
    end
  end

  describe "#castle_eligible" do
    it "returns position of roook if the king and one of rooks have not left their starting positions" do
      white_player.make_move('rook', ['a',1], ['d',2])
      expect(white_player.castle_eligible).to eql([['h',1]])
    end

    it "returns false if both of the rooks have left their starting position" do
      white_player.make_move('rook', ['a',1], ['d',2])
      white_player.make_move('rook', ['h',1], ['h',4])
      expect(white_player.castle_eligible).to eql(false)
    end

    it "returns false if the king has left its starting position" do
      white_player.make_move('king', ['e',1], ['e',3])
      expect(white_player.castle_eligible).to eql(false)
    end
  end
end