class GamePiece
  attr_reader :color, :position

  @@COLUMNS = ('a'..'h')
  @@ROWS = (1..8)

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

  def make_move(new_position)
    @position = new_position
  end

  def map_straight_path(new_position)
    side = position[0] <=> new_position[0]
    front_back = position[1] <=> new_position[1]
    direction = [side, front_back]
    path_array = []
    case direction
    when [0,-1]
      for y in @position[1]..new_position[1]
        path_array.push([new_position[0],y])
      end
    when [-1,0]
      for x in @position[0]..new_position[0]
        path_array.push([x,new_position[1]])
      end
    when [0,1]
      for y in (new_position[1]..@position[1]).reverse_each
        path_array.push([new_position[0],y])
      end
    when [1,0]
      for x in (new_position[0]..@position[0]).reverse_each
        path_array.push([x, new_position[1]])
      end
    else
      false
    end
    path_array
  end

  def map_diagonal_path(new_position)
    side = position[0] <=> new_position[0]
    front_back = position[1] <=> new_position[1]
    direction = [side, front_back]
    path_array = []
    iteration = 0
    case direction
    when [1,1]
      for x in (new_position[0]..@position[0]).reverse_each
        path_array.push([x,@position[1]-iteration])
        iteration += 1
      end
    when [1,-1]
      for x in (new_position[0]..@position[0]).reverse_each
        path_array.push([x,@position[1]+iteration])
        iteration += 1
      end
    when [-1,1]
      for x in @position[0]..new_position[0]
        path_array.push([x,@position[1]-iteration])
        iteration += 1
      end
    when [-1,-1]
      for x in @position[0]..new_position[0]
        path_array.push([x,@position[1]+iteration])
        iteration += 1
      end
    else
      false
    end
    path_array
  end

  private
  def generate_rand_move_straight(limit=false)
    direction = ["left", "right", "forward", "behind"].shuffle.first
    move = ["",0]
    until @@COLUMNS.include?(move[0]) && @@ROWS.include?(move[1])
      limit ? distance = rand(1..limit) : distance = rand(1..7)
      case direction
      when "left"
        move[0] = (position[0].ord-distance).chr
        move[1] = position[1]
      when "right"
        move[0] = (position[0].ord+distance).chr
        move[1] = position[1]
      when "forward"
        move[0] = position[0]
        move[1] = position[1] + distance
      when "behind"
        move[0] = position[0]
        move[1] = position[1] - distance
      end
    end
    move
  end

  def generate_rand_move_diagonal(limit=false)
    direction = ["behind-left", "behind-right", "forward-left", "forward-right"].shuffle.first
    move = ["",0]
    until @@COLUMNS.include?(move[0]) && @@ROWS.include?(move[1])
      limit ? distance = rand(1..limit) : distance = rand(1..7)
      case direction
      when "behind-left"
        move[0] = (position[0].ord-distance).chr
        move[1] = position[1] - distance
      when "behind-right"
        move[0] = (position[0].ord+distance).chr
        move[1] = position[1] - distance
      when "forward-left"
        move[0] = (position[0].ord-distance).chr
        move[1] = position[1] + distance
      when "forward-right"
        move[0] = (position[0].ord+distance).chr
        move[1] = position[1] + distance
      end
    end
    move
  end
end

class King < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u265A" : "\u2654"
  end

  def is_valid_move?(new_position)
    if is_move_straight?(new_position) == 1 || is_move_diagonal?(new_position) == 1 
      new_position
    else
      false
    end
  end

  def map_path(new_position)
    is_valid_move?(new_position) ? path_array = [@position, new_position] : false
  end

  def generate_random_move
    case rand(1)
    when 0
      move = generate_rand_move_straight(1)
    when 1
      move = generate_rand_move_diagonal(1)
    end
    move
  end
end

class Queen < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u265B" : "\u2655"
  end

  def is_valid_move?(new_position)
    if is_move_diagonal?(new_position) || is_move_straight?(new_position)
      new_position
    else
      false
    end
  end

  def map_path(new_position)
    if is_move_straight?(new_position) 
      map_straight_path(new_position)
    elsif is_move_diagonal?(new_position)
      map_diagonal_path(new_position)
    else
      false
    end
  end

  def generate_random_move
    case rand(1)
    when 0
      move = generate_rand_move_straight
    when 1
      move = generate_rand_move_diagonal
    end
    move
  end
end

class Bishop < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u265D" : "\u2657"
  end

  def is_valid_move?(new_position)
    if is_move_diagonal?(new_position)
      new_position
    else
      false
    end
  end

  def map_path(new_position)
    is_move_diagonal?(new_position) ? map_diagonal_path(new_position) : false
  end

  def generate_random_move
    generate_rand_move_diagonal
  end
end

class Knight < GamePiece
  attr_reader :display_code
  
  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u265E" : "\u2658"
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

  def map_path(new_position)
    is_valid_move?(new_position) ? [@postion, new_position] : false 
  end

  def generate_random_move
    direction = @moves.shuffle.first
    move = ["",0]
    until @@COLUMNS.include?(move[0]) && @@ROWS.include?(move[1])
      move[0] = (position[0].ord+direction[0]).chr
      move[1] = position[1] + direction[1]
    end
    move
  end
end

class Rook < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @display_code = @color == "white" ? "\u265C" : "\u2656"
  end

  def is_valid_move?(new_position)
    if is_move_straight?(new_position)
      new_position
    else
      false
    end
  end

  def map_path(new_position)
    is_move_straight?(new_position) ? map_straight_path(new_position) : false
  end

  def generate_random_move
    generate_rand_move_straight
  end
end

class Pawn < GamePiece
  attr_reader :display_code

  def initialize(color,position)
    super(color, position)
    @first_move = true
    @display_code = @color == "white" ? "\u265F" : "\u2659"
  end

  def is_valid_move?(new_position, overtake=false)
    if is_move_straight?(new_position) == 1 || (is_move_diagonal?(new_position) == 1 && overtake) || (is_move_straight?(new_position) == 2 && @first_move)
      if @color == "white"
        if overtake
          right = (position[0].ord+1).chr
          left = (position[0].ord-1).chr
          if [right, position[1]+1] == new_position || [left, position[1]+1] == new_position
            new_position
          else
            false
          end
        elsif @first_move && is_move_straight?(new_position) == 2
          @position[1]+2 == new_position[1] ? new_position : false
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
        elsif @first_move && is_move_straight?(new_position) == 2
          @position[1]-2 == new_position[1] ? new_position : false
        else
          @position[1]-1 == new_position[1] ? new_position : false
        end 
      end
    else
      false
    end
  end

  def make_move(new_position)
    super
    @first_move = false if @first_move
  end

  def map_path(new_position)
    is_valid_move?(new_position) ? [@postion, new_position] : false
  end

  def generate_random_move
    case rand(1)
    when 0
      @first_move ? limit = 2 : limit = 1 
      move = generate_rand_move_straight(limit)
    when 1
      move = generate_rand_move_diagonal(1)
    end
    move
  end
end