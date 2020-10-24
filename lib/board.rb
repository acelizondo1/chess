class Board
attr_reader :board
  def initialize
    @board = {}
    ("a".."h").each do |column|
      @board[column] = Array.new(8)
    end
  end

  def display_board
    puts "  a   b   c   d   e   f   g   h  "
    puts "  --------------------------------"
    (0..7).reverse_each.each do |row|
      board_row = "#{row+1}|"
      ("a".."h").each do |column|
        space = @board[column][row] ? @board[column][row].display_code: " "
        board_row += " #{space} |"
      end
      puts board_row
      puts "  --------------------------------"
    end
  end

  def update_board(white_pieces, black_pieces)
    white_pieces.each do |key, type|
      type.each do |white_piece|
        column = white_piece.position[0]
        row = white_piece.position[1]
        @board[column][row-1] = white_piece
      end
    end

    black_pieces.each do |key, type|
      type.each do |black_piece|
        column = black_piece.position[0]
        row = black_piece.position[1]
        @board[column][row-1] = black_piece
      end
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

  def is_check?(player_pieces, king_position)
    player_pieces.each do |key, piece_types|
      piece_types.each do |player_piece|
        if player_piece.is_valid_move?(king_position)
          return true if clear_path?(player_piece.map_path(king_position))
        end
      end
    end
    false
  end
end