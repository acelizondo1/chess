require './lib/pieces.rb'

class Player
attr_accessor :in_check
attr_reader :color, :active_pieces, :eliminated_pieces
  def initialize(player_color)
    @color = player_color
    @active_pieces = load_start_pieces
    @eliminated_pieces = []
    @in_check = false
    @computer = false
  end

  def make_move(piece, position, destination)
    @active_pieces[piece].each do |target_piece|
      return target_piece.make_move(destination) if target_piece.position == position
    end
    false
  end

  def is_valid_move?(piece, position, destination)
    @active_pieces[piece].each do |target_piece|
      unless space_occupied?(destination)
        return target_piece.is_valid_move?(destination) if target_piece.position == position
      else 
        return false
      end
    end
    false
  end

  def eliminate_piece(position)
    @active_pieces.each do |key, pieces|
      pieces.each do |piece|
        if piece.position == position
          type = piece.class.to_s.downcase
          @active_pieces[type].delete(piece)
          @eliminated_pieces.push(piece)
        end
      end
    end
    
  end

  def map_path(piece, position, destination)
    @active_pieces[piece].each do |target_piece|
      return target_piece.map_path(destination) if target_piece.position == position
    end
    false
  end

  def space_occupied?(position) 
    @active_pieces.each do |key, pieces|
      pieces.each do |piece|
        return true if piece.position == position
      end
    end
    false
  end

  private
  def load_start_pieces
    pieces = {}
    positions = color == "white" ? [['a',1],['b',1],['c',1],['d',1],['e',1],['f',1],['g',1],['h',1],['a',2],['b',2],['c',2],['d',2],['e',2],['f',2],['g',2],['h',2]] :
    [['a',8],['b',8],['c',8],['d',8],['e',8],['f',8],['g',8],['h',8],['a',7],['b',7],['c',7],['d',7],['e',7],['f',7],['g',7],['h',7]]
    
    pieces['rook']    = [Rook.new(color, positions[0]), Rook.new(color, positions[7])]
    pieces['knight']  = [Knight.new(color, positions[1]), Knight.new(color, positions[6])]
    pieces["bishop"]  = [Bishop.new(color, positions[2]), Bishop.new(color, positions[5])]
    pieces["queen"] = [Queen.new(color, positions[3])]
    pieces["king"]  = [King.new(color, positions[4])]
    pieces["pawn"] = []
    for i in 8..15
      pieces["pawn"].push(Pawn.new(color, positions[i]))
    end
    pieces
  end
end