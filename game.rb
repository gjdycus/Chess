require_relative 'player.rb'
require_relative 'board.rb'

class Game
  attr_accessor :players, :current_player, :board

  def initialize(player1, player2, board)
    @players = [player1, player2]
    @current_player = players.first
    @board = board
  end

  def current_player
    players.first
  end

  def play
    until game_over?
      take_turn
    end

    players.rotate!

    system("clear")
    current_player.display.render_board(:clear)
    puts "Checkmate! #{current_player.color.capitalize} wins!"
  end

  def take_turn
    start_pos, end_pos = current_player.move
    until board.register_move?(start_pos,end_pos) != false &&
          player_turn?(start_pos, current_player.color)
      start_pos, end_pos = current_player.move
    end
    board.move(start_pos, end_pos)
    players.rotate!
  end

  def game_over?
    board.checkmate?(current_player.color)
  end

  def player_turn?(pos, color)
    board[*pos].color == color
  end

end

board = Board.new
display = Display.new(board)
player1 = Player.new("Bobby", :white, display)
player2 = Player.new("Jimmy", :black, display)
game = Game.new(player1, player2, board)
game.play
