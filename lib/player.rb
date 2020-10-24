class Player
attr_reader :color, :active_pieces, :eliminated_pieces
  def initialize(player_color)
    @color = player_color
    @active_pieces = load_start_pieces
    @eliminated_pieces = []
  end

  def make_move(piece, position, destination)
    for target_piece in @active_pieces[piece]
      unless space_occupied?(destination)
        return target_piece.make_move(destination) if target_piece.position == position
      else 
        return false
      end
    end
  end

  def eliminate_piece(piece_object)

  end

  private
  def load_start_pieces
    pieces = {}
    positions = color == "white" ? [['a',1],['b',1],['c',1],['d',1],['e',1],['f',1],['g',1],['h',1],['a',2],['b',2],['c',2],['d',2],['e',2],['f',2],['g',2],['h',2]] :
    [['a',8],['b',8],['c',8],['d',8],['e',8],['f',8],['g',8],['h',8],['a',7],['b',7],['c',7],['d',7],['e',7],['f',7],['g',7],['h',7]]
    
    pieces['rook']    = [Rook.new(color, positions[0]), Rook.new(color, positions[7])]
    pieces['knight']  = [Knight.new(color, positions[1]), Knight.new(color, positions[6])]
    pieces["bishop"]  = [Bishop.new(color, positions[2]), Bishop.new(color, positions[5])]
    if color == "white"
      pieces["queen"] = [Queen.new(color, positions[3])]
      pieces["king"]  = [King.new(color, positions[4])]
    else
      pieces["queen"] = [Queen.new(color, positions[4])]
      pieces["king"]  = [King.new(color, positions[3])]
    end
    pieces["pawn"] = []
    for i in 8..15
      pieces["pawn"].push(Pawn.new(color, positions[i]))
    end
    pieces
  end

  def space_occupied?(position) 
    @active_pieces.each do |key, pieces|
      pieces.each do |piece|
        return true if piece.position == position
      end
    end
    false
  end
end