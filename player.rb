require_relative 'display.rb'

class Player
  attr_accessor :name, :color, :display

  def initialize(name, color, display)
    @name = name
    @color = color
    @display = display
  end

  def move
    start_pos = nil
    end_pos = nil

    until start_pos
      system("clear")
      puts "#{self.color.capitalize}\'s turn!"
      display.render_board(self.color)
      start_pos = display.get_input
    end

    display.selected = true

    until end_pos
      system("clear")
      puts "#{self.color.capitalize}\'s turn!"
      display.render_board(self.color)
      end_pos = display.get_input
    end

    display.selected = false

    [start_pos, end_pos]
  end

end
