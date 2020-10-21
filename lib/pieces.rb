class GamePiece
  attr_reader :color, :position
  def initialize(color, position)
    @color = color
    @position = position
  end

  def is_move_straight?(new_position)
    front_back = position[0] <=> new_position[0]
    side = position[1] <=> new_position[1]
    if (front_back == 1 || front_back == -1) && side == 0
      true
    elsif (side == 1 || side == -1) && front_back == 0
      true
    else
      false
    end
  end

  def is_move_diagonal?(new_position)

  end
end

class King < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end

class Queen < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end

class Bishop < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end

class Knight < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end

class Rook < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end

class Pawn < GamePiece
  def initialize(color,position)
    super(color, position)
  end
end