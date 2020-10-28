require './lib/board.rb'
require './lib/pieces.rb'
require './lib/player.rb'

describe Board do
  let!(:board) do
    @board = Board.new
  end

  let!(:white_pieces) do
      # @white_pieces = []
      # @white_pieces.push(Rook.new("white", ['a',1]))
      # @white_pieces.push(Knight.new("white", ['b',1]))
      # @white_pieces.push(Bishop.new("white", ['c',1]))
      # @white_pieces.push(King.new("white", ['d',1]))
      # @white_pieces.push(Queen.new("white", ['e',1]))
      # @white_pieces.push(Bishop.new("white", ['f',1]))
      # @white_pieces.push(Knight.new("white", ['g',1]))
      # @white_pieces.push(Rook.new("white", ['h',1]))
      white_player = Player.new("white")
      @white_pieces = white_player.active_pieces
  end

  let!(:black_pieces) do
      # @black_pieces = []
      # @black_pieces.push(Rook.new("black", ['a',8]))
      # @black_pieces.push(Knight.new("black", ['b',8]))
      # @black_pieces.push(Bishop.new("black", ['c',8]))
      # @black_pieces.push(Queen.new("black", ['d',8]))
      # @black_pieces.push(King.new("black", ['e',8]))
      # @black_pieces.push(Bishop.new("black", ['f',8]))
      # @black_pieces.push(Knight.new("black", ['g',8]))
      # @black_pieces.push(Rook.new("black", ['h',8]))
      black_player = Player.new("black")
      @black_pieces = black_player.active_pieces
  end

  describe "#initialize" do
    it "creates an empty board on creation" do
      expect(board.board).to eql({"a"=>[nil,nil,nil,nil,nil,nil,nil,nil],"b"=>[nil,nil,nil,nil,nil,nil,nil,nil],"c"=>[nil,nil,nil,nil,nil,nil,nil,nil],"d"=>[nil,nil,nil,nil,nil,nil,nil,nil],"e"=>[nil,nil,nil,nil,nil,nil,nil,nil],"f"=>[nil,nil,nil,nil,nil,nil,nil,nil],"g"=>[nil,nil,nil,nil,nil,nil,nil,nil],"h"=>[nil,nil,nil,nil,nil,nil,nil,nil]})
    end
  end

  describe "#update_board" do
    it "loads one side of of the board" do
      board.update_board(white_pieces, [])
      expect(board.board['a'][0]).to be_kind_of(Rook)
      expect(board.board['e'][0]).to be_kind_of(King)
      expect(board.board['g'][0]).to be_kind_of(Knight)
    end

    it "loads both sides of the board" do
      board.update_board(white_pieces, black_pieces)
      expect(board.board['a'][0]).to be_kind_of(Rook)
      expect(board.board['e'][0]).to be_kind_of(King)
      expect(board.board['g'][0]).to be_kind_of(Knight)
      expect(board.board['c'][7]).to be_kind_of(Bishop)
      expect(board.board['d'][7]).to be_kind_of(Queen)
      expect(board.board['h'][7]).to be_kind_of(Rook)
    end

    it "updates board after a piece moves" do
      board.update_board(white_pieces, black_pieces)
      board.board['a'][0].make_move(['a',4])
      board.update_board(white_pieces, black_pieces)
      expect(board.board['a'][3]).to be_kind_of(Rook)
      expect(board.board['a'][0]).to eql(nil)
    end
  end

  describe "#clear_path?" do
    it "returns true if no pieces in path array" do
      board.update_board(white_pieces, black_pieces)
      array = [['b',5],['c',4],['b',3]]
      expect(board.clear_path?(array)).to eql(true)
    end

    it "returns false if a piece is in the path array" do
      board.update_board(white_pieces, black_pieces)
      board.board['a'][0].make_move(['a',3])
      board.update_board(white_pieces, black_pieces)
      array = [['a',2],['a',3],['b',3],['c',3],['d',3]]
      expect(board.clear_path?(array)).to eql(false)
    end
  end

  describe "#is_check?" do
    it "returns true if 1 white piece is placing king in check" do
      board.update_board(white_pieces, black_pieces)
      black_pieces["king"][0].make_move(['d',5])
      white_pieces["rook"][0].make_move(['a',5])
      expect(board.is_check?(white_pieces, black_pieces["king"][0].position)).to eql(true)
    end

    it "returns true if multiple pieces have the king in check" do
      board.update_board(white_pieces, black_pieces)
      black_pieces["king"][0].make_move(['d',5])
      white_pieces["rook"][0].make_move(['a',5])
      white_pieces["knight"][0].make_move(['f',4])
      expect(board.is_check?(white_pieces, black_pieces["king"][0].position)).to eql(true)
    end

    it "returns false if the king is not in check" do
      board.update_board(white_pieces, black_pieces)
      expect(board.is_check?(black_pieces, white_pieces["king"][0].position)).to eql(false)
    end
  end

  describe "#is_checkmate?" do
    it "returns true if king cannot move out of check" do
      board.update_board(white_pieces, black_pieces)
      white_pieces["rook"][0].make_move(['d',6])
      black_pieces["pawn"][3].make_move(['d',5])
      expect(board.is_checkmate?(white_pieces, black_pieces["king"][0].position)).to eql(true)
    end
  end
end