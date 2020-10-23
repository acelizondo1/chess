class Board
attr_reader :board
  def initialize
    @board = {}
    for column in "a".."h"
      @board[column] = Array.new(8)
    end
  end

  def display_board
    puts "   a   b   c   d   e   f   g   h  "
    puts "  --------------------------------"
    for row in 0..7
      board_row = "#{row+1}|"
      for column in "a".."h"
        space = @board[column][row] ? @board[column][row].display_code: " "
        board_row += " #{space} |"
      end
      puts board_row
      puts "  --------------------------------"
    end
  end

  def update_board(white_pieces, black_pieces)
    for white_piece in white_pieces
      column = white_piece.positon[0]
      row = white_piece[1]
      @board[column][row] = white_piece
    end

    for black_piece in black_pieces
      column = black_piece.positon[0]
      row = black_piece[1]
      @board[column][row] = black_piece
    end
  end
end