require './lib/board.rb'
require './lib/pieces.rb'

describe Board do
  let!(:board) do
    @board = Board.new
  end

  let!(:white_pieces) do
      @white_pieces = []
      @white_pieces.push(Rook.new("white", ['a',1]))
      @white_pieces.push(Knight.new("white", ['b',1]))
      @white_pieces.push(Bishop.new("white", ['c',1]))
      @white_pieces.push(King.new("white", ['d',1]))
      @white_pieces.push(Queen.new("white", ['e',1]))
      @white_pieces.push(Bishop.new("white", ['f',1]))
      @white_pieces.push(Knight.new("white", ['g',1]))
      @white_pieces.push(Rook.new("white", ['h',1]))
  end

  let!(:black_pieces) do
      @black_pieces = []
      @black_pieces.push(Rook.new("black", ['a',8]))
      @black_pieces.push(Knight.new("black", ['b',8]))
      @black_pieces.push(Bishop.new("black", ['c',8]))
      @black_pieces.push(Queen.new("black", ['d',8]))
      @black_pieces.push(King.new("black", ['e',8]))
      @black_pieces.push(Bishop.new("black", ['f',8]))
      @black_pieces.push(Knight.new("black", ['g',8]))
      @black_pieces.push(Rook.new("black", ['h',8]))
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
      expect(board.board['d'][0]).to be_kind_of(King)
      expect(board.board['g'][0]).to be_kind_of(Knight)
    end

    it "loads both sides of the board" do
      board.update_board(white_pieces, black_pieces)
      expect(board.board['a'][0]).to be_kind_of(Rook)
      expect(board.board['d'][0]).to be_kind_of(King)
      expect(board.board['g'][0]).to be_kind_of(Knight)
      expect(board.board['c'][7]).to be_kind_of(Bishop)
      expect(board.board['d'][7]).to be_kind_of(Queen)
      expect(board.board['h'][7]).to be_kind_of(Rook)
    end

    it "updates board after a piece moves" do
      board.update_board(white_pieces, black_pieces)
      board.board['a'][0].make_move(['a',4])
      board.update_board(white_pieces, black_pieces)
      board.display_board
      expect(board.board['a'][3]).to be_kind_of(Rook)
      expect(board.board['a'][0]).to eql(nil)
    end
  end
end