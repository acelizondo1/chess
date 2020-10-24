class Board
attr_reader :board
  def initialize
    @board = {}
    for column in "a".."h"
      @board[column] = Array.new(8)
    end
  end

  def display_board
    puts "  a   b   c   d   e   f   g   h  "
    puts "  --------------------------------"
    for row in (0..7).reverse_each
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
      column = white_piece.position[0]
      row = white_piece.position[1]
      @board[column][row-1] = white_piece
    end

    for black_piece in black_pieces
      column = black_piece.position[0]
      row = black_piece.position[1]
      @board[column][row-1] = black_piece
    end

    for column in "a".."h"
      for row in 0..7
        if @board[column][row]
          @board[column][row] = nil unless @board[column][row].position == [column, row+1]
        end
      end
    end
  end

  def clear_path?(path_array)
    path_array.each do |spot|
      return false unless @board[spot[0]][spot[1]-1] == nil
    end
    true
  end
end