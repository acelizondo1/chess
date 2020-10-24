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
    it "returns the destination of the moved piece if valid move" do
      expect(white_player.make_move("rook", ['h', 1], ['h', 5])).to eql(['h',5])
    end

    it "returns false if invalid move is requested" do
      expect(white_player.make_move("pawn", ['b',2], ['b', 5])).to eql(false)
    end

    it "returns false if destination contains another white_player piece" do
      white_player.make_move("pawn", ['a',2], ['a',3])
      expect(white_player.make_move("rook", ['a',1], ['a',3])).to eql(false)
    end
  end

  describe "#eliminate_piece" do
    it "removes object from active_pieces" do
      pawn_to_eliminate = white_player.active_pieces["pawn"][3]
      white_player.eliminate_piece(pawn_to_eliminate)
      expect(white_player.active_pieces.include?(pawn_to_eliminate)).to eql(false)
    end

    it "adds object to eliminated_pieces" do
      pawn_to_eliminate = white_player.active_pieces["pawn"][3]
      white_player.eliminate_piece(pawn_to_eliminate)
      expect(white_player.eliminated_pieces.include?(pawn_to_eliminate)).to eql(true)
    end

    it "does nothing if the object is not an active piece" do
      pawn_to_eliminate = white_player.active_pieces["pawn"][3]
      white_player.eliminate_piece(pawn_to_eliminate)
      expect{white_player.eliminate_piece(pawn_to_eliminate)}.to_not change{white_player.active_pieces}
    end
  end
end