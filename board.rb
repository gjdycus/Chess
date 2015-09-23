require_relative 'piece.rb'
require 'byebug'

class Board
  attr_accessor :board

  def initialize(setup = true)
    @board = Array.new(8) {Array.new(8) }
    set_up_board if setup
  end

  def set_up_board
    setup_empty_pieces
    set_up_outer_rows(0, :black)
    set_up_outer_rows(7, :white)
    set_up_inner_rows(1, :black)
    set_up_inner_rows(6, :white)
  end

  def setup_empty_pieces
    8.times do |row|
      8.times do |col|
        self[row, col] = EmptyPiece.new(self,[row,col], :clear)
      end
    end
  end

  def set_up_outer_rows(i, color)
    self[i, 0] = Rook.new(self, [i, 0], color)
    self[i, 1] = Knight.new(self, [i, 1], color)
    self[i, 2] = Bishop.new(self, [i, 2], color)
    self[i, 3] = Queen.new(self, [i, 3], color)
    self[i, 4] = King.new(self, [i, 4], color)
    self[i, 5] = Bishop.new(self, [i, 5], color)
    self[i, 6] = Knight.new(self, [i, 6], color)
    self[i, 7] = Rook.new(self, [i, 7], color)
  end

  def set_up_inner_rows(i, color)
    8.times do |col|
      self[i, col] = Pawn.new(self, [i, col], color)
    end
  end


  def register_move?(start_pos, end_pos)
    if self[*start_pos].empty?
      puts "No piece at #{start_pos}"
      sleep(0.6)
      return false
    elsif move_into_check?(start_pos,end_pos, self[*start_pos].color)
      puts "Cannot move into check! Try another move."
      sleep(1)
      return false
    elsif !valid_move?(start_pos, end_pos)
      puts "Cannot be moved to #{end_pos}"
      sleep(0.6)
      return false
    end
    true
  end

  def move(start_pos,end_pos)
    self[*end_pos] = self[*start_pos]
    self[*end_pos].pos = end_pos
    self[*start_pos] = EmptyPiece.new(self,start_pos,:clear)
    self[*end_pos].already_moved = true
  end

  def valid_move?(start_pos, end_pos)
    return false unless in_bounds?(end_pos)

    if !self[*end_pos].empty?
      return false unless attacking?(start_pos,end_pos)
    end

    return false unless self[*start_pos].moves.include?(end_pos)

    return false if move_into_check?(start_pos,end_pos, self[*start_pos].color)

    true
  end

  def in_bounds?(pos)
    pos.none? { |el| el > 7 || el < 0 }
  end

  def attacking?(start_pos,end_pos)
    unless self[*end_pos].empty?
      return true if self[*start_pos].color != self[*end_pos].color
    end
    false
  end

  def [](x, y)
    board[x][y]
  end

  def []=(x, y, value)
    board[x][y] = value
  end

  def rows
    board
  end

  def pieces
    @board.flatten
  end

  def move_into_check?(start_pos, end_pos, color)
    new_board = self.dup
    new_board.move(start_pos,end_pos)
    new_board.in_check?(color)
  end

  def in_check?(color)
    king_pos = find_king(color)
    pieces.each do |piece|
      return true if piece.moves.include?(king_pos)
    end
    false
  end

  def checkmate?(color)
    pieces.each do |piece|
      piece.moves.each do |move|
        if piece.color == color && valid_move?(piece.pos, move)
          return false
        end
      end
    end
    true
  end

  def find_king(color)
    rows.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        pos = [row_index,col_index]
        return pos if ( self[*pos].is_a?(King) && self[*pos].color == color)
      end
    end
  end

  def dup
    dup_board = Board.new(false)
    rows.each_with_index do |row, row_index|
      row.each_with_index do |col, col_index|
        dup_board[row_index, col_index] = self[row_index, col_index].dup(dup_board)
      end
    end
    dup_board
  end
end
