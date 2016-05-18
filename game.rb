require_relative "board"


class Game
  def initialize(board)
    @board = board
  end

  def play
    until @board.won?
      @board.render
      location = get_location
      command = get_command
      if command == :F
        @board.set_flag(location)
      elsif @board.bomb_in_position?(location[0],location[1])
        p "you lost bomb exploded"
        return
      else
        @board.update(location)
      end
    end
    p "YOU WIN"
  end

  def get_location
    puts "Enter location eg.'1,2'"
    gets.chomp.split(",").map(&:to_i)
  end

  def get_command
    puts "Enter [F]lag or [S]how"
    gets.chomp.to_sym
  end
end



if __FILE__ == $PROGRAM_NAME
  board = Board.new
  game = Game.new(board)
  game.play
end
