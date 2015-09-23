require_relative 'board.rb'

class Piece
  attr_accessor :board, :pos, :color, :already_moved


  def initialize(board, pos, color = :clear)
    @board = board
    @pos = pos
    @color = color
    @already_moved = false
  end

  def empty?
    false
  end

  def dup(board)
    self.class.new(board, self.pos.dup, self.color)
  end
end

class SlidingPiece < Piece
  def moves
    moves = []

    move_dirs.each do |dx, dy|
      moves += expand_moves_in_dir(dx, dy)
    end

    moves
  end

  def horizontal_dirs
    [[-1, 0],
    [0, -1],
    [0, 1],
    [1, 0]]
  end

  def diagonal_dirs
    [[-1, -1],
    [-1, 1],
    [1, -1],
    [1, 1]]
  end

  def expand_moves_in_dir(dx, dy)
    x, y = self.pos
    moves = []
    while true
      x, y = x + dx, y + dy
      pos = [x, y]

      break unless board.in_bounds?(pos)

      if board[*pos].empty?
        moves << pos
      else
        moves << pos if board[*pos].color != self.color

        break
      end
    end
    moves
  end
end

class SteppingPiece < Piece
  def moves
    moves = []
    move_dirs.each do |dx, dy|
      x, y = self.pos
      position = [x + dx, y + dy]

      next unless board.in_bounds?(position)

      if board[*position].empty?
        moves << position
      elsif board[*position].color != self.color
        moves << position
      end
    end
    moves
  end
end

class Bishop < SlidingPiece
  def move_dirs
    diagonal_dirs
  end
end

class Rook < SlidingPiece
  def move_dirs
    horizontal_dirs
  end
end

class Queen < SlidingPiece
  def move_dirs
    horizontal_dirs + diagonal_dirs
  end
end

class Knight < SteppingPiece
  def move_dirs
    [[-2, -1], [-2, 1], [-1, 2], [1, 2], [2, 1], [2, -1], [1, -2], [-1, -2]]
  end
end

class King < SteppingPiece
  def move_dirs
    [[0, -1], [-1, -1], [-1, 0], [-1, 1], [0, 1], [1, 1], [1, 0], [1, -1]]
  end
end

class Pawn < Piece
  attr_accessor :already_moved
  def initialize(board, pos, color)
      super
      @already_moved = false
  end

  def forward_steps
    x, y = self.pos
    step = [x + forward_dir, y]
    return [] unless board.in_bounds?(step) && board[*step].empty?

    steps = [step]
    two_step = [x + 2 * forward_dir, y]
    steps << two_step unless already_moved
    steps
  end

  def side_steps
    x, y = self.pos

    side_moves = [[x + forward_dir, y - 1], [x + forward_dir, y + 1]]

    side_moves.select do |new_pos|
      next false unless board.in_bounds?(new_pos)

      board.attacking?(self.pos, new_pos)
    end
  end

  def forward_dir
    (self.color == :white) ? -1 : 1
  end

  def moves
    forward_steps + side_steps
  end
end

class EmptyPiece < Piece
  def initialize(board,pos,color = :clear)
    super(board,pos, color = :clear)
  end

  def empty?
    true
  end

  def moves
    [self.pos]
  end
end
