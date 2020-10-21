class GamePiece
  attr_reader :color, :position
  def initialize(color, position)
    @color = color
    @position = position
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