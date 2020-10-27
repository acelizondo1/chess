require './lib/player.rb'
require './lib/board.rb'

class Game
  attr_reader :current_player, :opponent_player, :board

  @@SPECIAL_COMMANDS = ["help", "yield", "save", "yield"]

  def initialize
    @white_player = Player.new("white")
    @black_player = Player.new("black")
    @board = Board.new
    @board.update_board(@white_player.active_pieces,@black_player.active_pieces)
    @current_player = @white_player
    @opponent_player = @black_player
    @winner = false
  end

  def start_game

  end

  def play_game
    until @winner
      player_move = get_valid_move
      if player_move.class == Array
        
      end

    end
  end

  def process_move(player_move)
    if @opponent_player.space_occupied?(player_move[2])
      @opponent_player.eliminate_piece(player_move[2])
    end
    @current_player.make_move(player_move[0],player_move[1],player_move[2])
    @board.update_board(@white_player.active_pieces, @black_player.active_pieces)
    # if @board.is_check?(@current_player.active_pieces,@opponent_player.active_pieces['king'][0])
    #   @opponent_player.in_check = true
    #   @winner = @current_player if @board.is_checkmate?(@current_player.active_pieces,@opponent_player.active_pieces['king'][0])
    # end
  end

  def get_valid_move 
    valid_move = false
    clear_path = false
    until valid_move && clear_path
      player_move = get_input
      if @@SPECIAL_COMMANDS.include?(player_move)
        break
      else
        valid_move = @current_player.is_valid_move?(player_move[0],player_move[1],player_move[2])
        clear_path = @board.clear_path?(@current_player.map_path(player_move[0],player_move[1],player_move[2]))
      end
    end
    player_move
  end

  def get_input
    valid_input = false
    until valid_input
      puts "#{@current_player.color.capitalize} player please enter your move:"
      user_input = gets.chomp
      user_input = clean_input(user_input)
      if user_input && input_in_range?(user_input[0], user_input[1], user_input[2])
        valid_input = true
      end
    end
    user_input
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