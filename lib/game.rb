require 'yaml'

require './lib/player.rb'
require './lib/board.rb'

class Game
  attr_reader :current_player, :opponent_player, :board, :winner, :white_player, :black_player

  @@SPECIAL_COMMANDS = ["help", "yield", "save", "yield", "castle"]

  def initialize
    @white_player = Player.new("white")
    @black_player = Player.new("black")
    @board = Board.new
    update_board
    @current_player = @white_player
    @opponent_player = @black_player
    @winner = false
  end

  def start_game
    game_type = ""
    until game_type == "load" || game_type == "new"
      puts "Would you like to:\nStart a new game(new) or Load the last saved game(load)"
      game_type = gets.strip.downcase
    end

    case game_type
    when "new"
      player_type = ""
      until player_type == "player" || player_type == "computer"
        puts "Who is your opponent:\nAnother player(player) or The computer(computer)"
        player_type = gets.strip.downcase
      end
      @black_player = ComputerPlayer.new("black") if player_type == "computer"
    when "load"
      load_game
    end
    play_game
  end

  def play_game
    until @winner
      @board.display_board(@white_player.eliminated_pieces,@black_player.eliminated_pieces)
      player_move = get_valid_move
      if player_move.class == Array
        process_move(player_move)
        switch_current_player
      elsif @@SPECIAL_COMMANDS.include?(player_move) && player_move != "castle"
        run_special_command(player_move)
      end
    end
    @board.display_board(@white_player.eliminated_pieces,@black_player.eliminated_pieces)
    puts "#{@winner.color.capitalize} player has won the game!"
  end

  def process_move(player_move)
    if @current_player.class == ComputerPlayer
      puts "Computer has made the move #{player_move[0]} #{player_move[1][0]}#{player_move[1][1]} #{player_move[2][0]}#{player_move[2][1]}"
    end
    if @opponent_player.space_occupied?(player_move[2])
      @opponent_player.eliminate_piece(player_move[2])
    end
    @current_player.make_move(player_move[0],player_move[1],player_move[2])
    update_board
    if @board.is_check?(@current_player.active_pieces,@opponent_player.active_pieces['king'][0].position)
      @opponent_player.in_check = true
      if @board.is_checkmate?(@current_player.active_pieces,@opponent_player.active_pieces)
        puts "Checkmate!"
        @winner = @current_player 
      else 
        puts "#{@opponent_player.color.capitalize} player is in check!"
      end
    end
    pawn_promotion(@current_player.find_piece(player_move[0],player_move[2])) if player_move[0] == "pawn"
  end

  def get_valid_move 
    valid_move = false
    clear_path = false
    until valid_move && clear_path
      unless @current_player.class == ComputerPlayer
        player_move = get_input
      else
        player_move = @black_player.generate_random_move
      end
      if @@SPECIAL_COMMANDS.include?(player_move)
        if player_move == "castle"
          break if player_castle
        else
          break
        end
      else
        if @opponent_player.space_occupied?(player_move[2]) && player_move[0] == "pawn"
          valid_move = @current_player.is_valid_move?(player_move[0],player_move[1],player_move[2],true)
          clear_path = @board.clear_path?(@current_player.map_path(player_move[0],player_move[1],player_move[2],true))
        else
          valid_move = @current_player.is_valid_move?(player_move[0],player_move[1],player_move[2])
          clear_path = @board.clear_path?(@current_player.map_path(player_move[0],player_move[1],player_move[2]))
        end
        unless !@current_player.in_check || (@current_player.in_check && remove_check?(player_move))
          valid_move = false
          clear_path = false
        end
      end
    end
    player_move
  end

  def get_input
    valid_input = false
    until valid_input
      puts "#{@current_player.color.capitalize} player please enter your move(enter 'help' for possible commands):"
      user_input = gets.chomp
      if @@SPECIAL_COMMANDS.include?(user_input.downcase)
        user_input = user_input.downcase
        valid_input = true
      else
        user_input = clean_input(user_input)
        if user_input && input_in_range?(user_input[0], user_input[1], user_input[2])
          valid_input = true
        end
      end
    end
    user_input
  end

  def remove_check?(player_move)
    board_copy = Marshal.load(Marshal.dump(@board))
    current_player_copy = Marshal.load(Marshal.dump(@current_player))
    opponent_player_copy = Marshal.load(Marshal.dump(@opponent_player))

    if opponent_player_copy.space_occupied?(player_move[2])
      opponent_player_copy.eliminate_piece(player_move[2])
    end
    current_player_copy.make_move(player_move[0],player_move[1],player_move[2])
    board_copy.update_board(current_player_copy.active_pieces, opponent_player_copy.active_pieces)

    board_copy.is_check?(opponent_player_copy.active_pieces,current_player_copy.active_pieces['king'][0].position) ? false : true
  end

  def player_castle
    castle_eligible = @current_player.castle_eligible
    if castle_eligible
      paths = []
      castle_eligible.each do |position|
        paths.push(@current_player.map_path("king", @current_player.active_pieces['king'][0].position, position,true))
      end
      paths.each do |path|
        if @board.clear_path?(path[1..path.length-2])
          path[0..path.length-2].each do |spot|
            return false if @board.is_check?(@opponent_player.active_pieces, spot)
          end
          @current_player.make_move('king', @current_player.active_pieces['king'][0].position, path[2])
          @current_player.make_move('rook', path[path.length-1], path[1])
          update_board
          return true
        end
      end
    else
      false
    end
  end

  def pawn_promotion(pawn)
    promotion_pieces = ["queen","bishop","knight","rook"]
    if (pawn.color == "white" && pawn.position[1] == 8) || (pawn.color == "black" && pawn.position[1] == 1)
      promotion_type = ""
      until promotion_pieces.include?(promotion_type)
        puts "What would you like to promote your pawn to?"
        promotion_type = gets.strip.downcase
      end
      case promotion_type
      when "queen"
        promotion_piece = Queen.new(pawn.color, pawn.position)
      when "bishop"
        promotion_piece = Bishop.new(pawn.color, pawn.position)
      when "knight"
        promotion_piece = Knight.new(pawn.color, pawn.position)
      when "rook"
        promotion_piece = Rook.new(pawn.color, pawn.position)
      end

      @current_player.active_pieces["pawn"].delete(pawn)
      @current_player.active_pieces[promotion_type].push(promotion_piece)
      update_board
      return true
    end
    return false
  end

  def update_board
    @board.update_board(@white_player.active_pieces,@black_player.active_pieces)
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

  def switch_current_player
    if @current_player == @white_player
      @current_player = @black_player
      @opponent_player = @white_player
    else
      @current_player = @white_player
      @opponent_player = @black_player
    end
  end

  def save_game
    p "save"
    File.open("save_game.yml", "w") do |file|
      data = YAML.dump ({
          :white_player => @white_player,
          :black_player => @black_player,
          :board => @board,
          :current_player => @current_player,
          :opponent_player => @opponent_player,
          :winner => @winner
      })
      file.puts data
    end
    puts "You've successfully saved your game. Goodbye"
    exit(0)
  end

  def load_game
    load_data = YAML.load(File.read("save_game.yml"))
    @white_player = load_data[:white_player]
    @black_player = load_data[:black_player]
    @board = load_data[:board]
    @current_player = load_data[:current_player]
    @opponent_player = load_data[:opponent_player]
    @winner = load_data[:winner]
  end

  def run_special_command(command)
    case command
    when 'help'
      puts "Enter in a valid move in the format 'piece current_position desitination' eg. 'pawn a2 a3'\nEnter 'castle' to run the move when valid\n\nEnter 'yield' to forfeit the game\nEnter 'save' to save your current match'\nEnter 'load' to load the last saved game"
    when 'yield'
      @winner = @opponent_player
      puts "#{@current_player.color.capitalize} player has yielded"
    when 'save'
      save_game
    when 'load'
      load_game
    end
  end
end