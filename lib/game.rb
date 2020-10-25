require './lib/player.rb'
require './lib/board.rb'

class Game

  def initialize
    @white_player = Player.new("white")
    @black_player = Player.new("black")
    @current_player_turn = @white_player
    @winner = false
  end

  def start_game
    
  end
end