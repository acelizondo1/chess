require './lib/player.rb'
require './lib/board.rb'

class Game

  def initialize
    @white_player = Player.new("white")
    @black_player = Player.new("black")
    @board = Board.new
    @current_player_turn = @white_player
    @winner = false
  end

  def start_game

  end

  def get_input

    valid_input = false
    until valid_input
      puts "#{current_player.color} player please enter your move:"
      user_input = gets.chomp
      user_input.split(" ")
      piece = user_input[0].downcase
      position = user_input[1].split("")
      destination = user_input[1].split("")
      if input_in_range?(piece, position, destination)

      end

    end
  end

  private
  def input_in_range?(piece, position, destination)
    valid_pieces = ['king','queen','bishop','knight','rook','pawn']
    valid_rows = 1..8
    valid_columns = "a".."h"

    if valid_pieces.include?(piece) && valid_columns.include?(position[0]) && valid_columns.include?(destination[0]) && valid_rows.include?(position[1]) && valid_rows.include?(destination[1])
      true 
    else
      false
    end
  end

  def clean_input(user_input) 
    begin
      user_input = user_input.split(" ")
      piece = user_input[0].downcase
      position = user_input[1].split("")
      position[0] = position[0].downcase
      position[1] = position[1].to_i
      destination = user_input[2].split("")
      destination[0] = destination[0].downcase
      destination[1] = destination[1].to_i
      raise ArgumentError.new("Invalid coordinates") if destination[1] == 0 || position[1] == 0 || destination[0].count("a-zA-Z") == 0 || position[0].count("a-zA-Z") == 0
      clean_inputs = [piece, position, destination]
    rescue 
      false
    end
  end
end