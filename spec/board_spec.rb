require './lib/board.rb'

describe Board do
  let!(:board) do
    @board = Board.new
  end

  describe "#initialize" do
    it "creates an empty board on creation" do
      expect(board.board).to eql({"a"=>[nil,nil,nil,nil,nil,nil,nil,nil],"b"=>[nil,nil,nil,nil,nil,nil,nil,nil],"c"=>[nil,nil,nil,nil,nil,nil,nil,nil],"d"=>[nil,nil,nil,nil,nil,nil,nil,nil],"e"=>[nil,nil,nil,nil,nil,nil,nil,nil],"f"=>[nil,nil,nil,nil,nil,nil,nil,nil],"g"=>[nil,nil,nil,nil,nil,nil,nil,nil],"h"=>[nil,nil,nil,nil,nil,nil,nil,nil]})
    end
  end
end