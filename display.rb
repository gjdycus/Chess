require 'colorize'
require_relative 'board.rb'
require_relative 'cursorable.rb'

class Display
  include Cursorable

  PIECE_MAP ={
    "Rook_white" => "♖" ,
    "Knight_white" => "♘",
    "Bishop_white" => "♗",
    "Queen_white" => "♕",
    "King_white" => "♔",
    "Pawn_white" => "♙",
    "Rook_black" => "♜" ,
    "Knight_black" => "♞",
    "Bishop_black" => "♝",
    "King_black" => "♚",
    "Queen_black" => "♛",
    "Pawn_black" =>"♟",
    "EmptyPiece_clear" => " "
  }
  attr_accessor :board, :cursor_pos, :selected

  def initialize(board)
    @board = board
    @cursor_pos = [6,4]
    @selected = false
  end

  def render_board(color)
    board.rows.each_with_index do |row, row_index|
      row.each_with_index do |piece, col_index|
        pos = [row_index,col_index]
        print "#{PIECE_MAP["#{piece.class.to_s}_#{piece.color.to_s}"]} "\
        .colorize(colors_for(pos,color))
      end
      print "\n"
    end
  end

  def colors_for(pos, color)
    if pos == cursor_pos
      bg = :yellow
    elsif (board[*cursor_pos].moves.include?(pos) \
                && !selected \
                && board.valid_move?(cursor_pos, pos) \
                && board[*cursor_pos].color == color)
      bg = :light_green
    elsif pos.reduce(:+).odd?
      bg = :white
    else
      bg = :blue
    end
    { background: bg, color: :black }
  end
end
