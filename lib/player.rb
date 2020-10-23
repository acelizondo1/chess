class Player
attr_reader :color, :active_pieces, :eliminated_pieces
  def initialize(player_color)
    @color = player_color
    @active_pieces = load_start_pieces
    @eliminated_pieces = []
  end

  private
  def load_start_pieces
    pieces = []
    positions = color == "white" ? [['a',1],['b',1],['c',1],['d',1],['e',1],['f',1],['g',1],['h',1],['a',2],['b',2],['c',2],['d',2],['e',2],['f',2],['g',2],['h',2]] :
    [['a',8],['b',8],['c',8],['d',8],['e',8],['f',8],['g',8],['h',8],['a',7],['b',7],['c',7],['d',7],['e',7],['f',7],['g',7],['h',7]]
    
    pieces.push(Rook.new(color, positions[0]))
    pieces.push(Knight.new(color, positions[1]))
    pieces.push(Bishop.new(color, positions[2]))
    if color == "white"
      pieces.push(Queen.new(color, positions[3]))
      pieces.push(King.new(color, positions[4]))
    else
      pieces.push(King.new(color, positions[3]))
      pieces.push(Queen.new(color, positions[4]))
    end
    pieces.push(Bishop.new(color, positions[5]))
    pieces.push(Knight.new(color, positions[6]))
    pieces.push(Rook.new(color, positions[7]))
    for i in 8..15
      pieces.push(Pawn.new(color, positions[i]))
    end
    pieces
  end
end