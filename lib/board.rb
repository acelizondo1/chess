class Board
attr_reader :board
  def initialize
    @board = {}
    for column in "a".."h"
      @board[column] = Array.new(8)
    end
  end
end