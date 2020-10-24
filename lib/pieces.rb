class GamePiece
  attr_reader :color, :position
  def initialize(color, position)
    @color = color
    @position = position
  end

  def is_move_straight?(new_position)
    side = position[0] <=> new_position[0]
    front_back = position[1] <=> new_position[1]
    if (front_back == 1 || front_back == -1) && side == 0
      difference = position[1] - new_position[1]
      difference > 0 ? difference : difference * -1
    elsif (side == 1 || side == -1) && front_back == 0
      difference = position[0].ord - new_position[0].ord
      difference > 0 ? difference : difference * -1
    else
      false
    end
  end

  def is_move_diagonal?(new_position)
    side = @position[0] <=> new_position[0]
    front_back = @position[1] <=> new_position[1]
    direction = [side, front_back]
    iteration = 0
    case direction
      when [1,1]
        for x in (new_position[0]..@position[0]).reverse_each
          return iteration if new_position == [x, @position[1]-iteration]
          iteration += 1
        end
      when [1,-1]
        for x in (new_position[0]..@position[0]).reverse_each
          return iteration if new_position == [x, @position[1]+iteration]
          iteration += 1
        end
      when [-1,1]
        for x in @position[0]..new_position[0]
          return iteration if new_position == [x, @position[1]-iteration]
          iteration += 1
        end
      when [-1,-1]
        for x in @position[0]..new_position[0]
          return iteration if new_position == [x, @position[1]+iteration]
          iteration += 1
        end
      else
        false
      end
      false
  end

  def make_move(position)
    return false
  end

  def make_move(new_position)
    @position = new_position
  end
end

class King < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2654" : "\u265A"
  end

  def is_valid_move?(new_position)
    if is_move_straight?(new_position) == 1 || is_move_diagonal?(new_position) == 1 
      new_position
    else
      false
    end
  end
end

class Queen < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2655" : "\u265B"
  end

  def is_valid_move?(new_position)
    if is_move_diagonal?(new_position) || is_move_straight?(new_position)
      new_position
    else
      false
    end
  end
end

class Bishop < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2657" : "\u265D"
  end

  def is_valid_move?(new_position)
    if is_move_diagonal?(new_position)
      new_position
    else
      false
    end
  end
end

class Knight < GamePiece
  attr_reader :display_code
  
  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2658" : "\u265E"
    @moves = [[2,1],[2,-1],[1,2],[-1,2],[1,-2],[-1,-2],[-2,1],[-2,-1]]
  end

  def is_valid_move?(new_position)
    @moves.each do |move|
      row = @position[1] + move[0]
      column = (position[0].ord+move[1]).chr
      if [column,row] == new_position
        return new_position
      end
    end
    false
  end
end

class Rook < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2656" : "\u265C"
  end

  def is_valid_move?(new_position)
    if is_move_straight?(new_position)
      new_position
    else
      false
    end
  end
end

class Pawn < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u2659" : "\u265E"
  end

  def is_valid_move?(new_position, overtake=false)
    if is_move_straight?(new_position) == 1 || (is_move_diagonal?(new_position) == 1 && overtake)
      if @color == "white"
        if overtake
          right = (position[0].ord+1).chr
          left = (position[0].ord-1).chr
          if [right, position[1]+1] == new_position || [left, position[1]+1] == new_position
            new_position
          else
            false
          end
        else
          @position[1]+1 == new_position[1] ? new_position : false
        end 
      else
        if overtake
          right = (position[0].ord+1).chr
          left = (position[0].ord-1).chr
          if [right, position[1]-1] == new_position || [left, position[1]-1] == new_position
            new_position
          else
            false
          end
        else
          @position[1]-1 == new_position[1] ? new_position : false
        end 
      end
    else
      false
    end
  end
end