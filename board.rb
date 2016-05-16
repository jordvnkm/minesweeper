require_relative 'tile'
require "byebug"

class Board
  attr_accessor :grid, :seen

  def initialize
    @grid = Array.new(9) {Array.new(9) {nil}}
    plant_bombs
    plant_numbers
    @seen = []
  end

  def [] (pos)
    x, y = pos
    @grid[x][y]
  end

  def []= (pos, value)
    x, y = pos
    @grid[x][y] = value
  end

  def plant_bombs
    10.times do
      row = (0..8).to_a.sample
      col = (0..8).to_a.sample
      until self[[row,col]] == nil
        row = (0..8).to_a.sample
        col = (0..8).to_a.sample
      end
      self[[row,col]] = Tile.new(:b)
    end
  end

  def plant_numbers
    71.times do
      row = (0..8).to_a.sample
      col = (0..8).to_a.sample
      until self[[row,col]] == nil
        row = (0..8).to_a.sample
        col = (0..8).to_a.sample
      end

      if bombs_adjacent?([row,col])
        self[[row,col]] = Tile.new(adjacent_count([row,col]))
      else
        self[[row, col]] = Tile.new(:_)
      end
    end
  end


  def render
    @grid.each do |row|
      row.each do |tile|
        if tile.flagged
          print " F "
        elsif tile.hidden
          print " * "
        else
          print " #{tile.value} "
        end
      end
      print "\n"
    end
  end

  def adjacent_count(pos)
    row, col = pos
    count = 0
    if bomb_in_position?(row - 1, col) #checking above
      count += 1
    end
    if bomb_in_position?(row + 1, col) #checking below
      count += 1
    end
    if bomb_in_position?(row, col + 1) #checking right
      count += 1
    end
    if bomb_in_position?(row, col - 1) #checking left
      count += 1
    end

    if bomb_in_position?(row - 1, col - 1) #checking above
      count += 1
    end
    if bomb_in_position?(row - 1, col+ 1) #checking below
      count += 1
    end
    if bomb_in_position?(row + 1, col + 1) #checking right
      count += 1
    end
    if bomb_in_position?(row + 1, col - 1) #checking left
      count += 1
    end

    count
  end

  def bombs_adjacent?(pos)
    row, col = pos
    if bomb_in_position?(row - 1, col) #checking above
      return true
    elsif bomb_in_position?(row + 1, col) #checking below
      return true
    elsif bomb_in_position?(row, col + 1) #checking right
      return true
    elsif bomb_in_position?(row, col - 1) #checking left
      return true

    elsif bomb_in_position?(row - 1, col - 1) #checking above
      return true
    elsif bomb_in_position?(row - 1, col+ 1) #checking below
      return true
    elsif bomb_in_position?(row + 1, col + 1) #checking right
      return true
    elsif bomb_in_position?(row + 1, col - 1) #checking left
      return true
    else
      false
    end
  end

  def bomb_in_position?(row, col)
    if row < 0 || row > 8
      return false
    elsif col < 0 || col > 8
      return false
    end

    return false if self[[row,col]] == nil

    if self[[row, col]].value == :b
      return true
    else
      return false
    end
  end

  def update(pos)
    self[pos].hidden = false
    if !bombs_adjacent?(pos)
      update_adjacent(pos)
    end
  end

  def update_adjacent(pos)
    row, col = pos
    return if row < 0 || row > 8
    return if col < 0 || col > 8

      p pos
    update([row - 1, col]) unless row-1<0 || !@grid[row-1][col].hidden
    update([row + 1, col]) unless row+1>8 || !@grid[row+1][col].hidden
    update([row, col + 1]) unless col+1>8  || !@grid[row][col+1].hidden
    update([row, col - 1]) unless col-1<0  || !@grid[row][col-1].hidden

    update([row - 1, col - 1]) unless row-1<0 || col-1<0  || !@grid[row - 1][col - 1].hidden
    update([row - 1, col+ 1]) unless row-1<0 || col+1>8  || !@grid[row - 1][col+ 1].hidden
    update([row + 1, col + 1]) unless row+1>8 || col+1>8  || !@grid[row + 1][col + 1].hidden
    update([row + 1, col - 1]) unless row+1>8 || col-1<0  || !@grid[row + 1][col - 1].hidden
  end

  def won?
    @grid.each do |row|
      row.each do |tile|
        if tile.value != :b && tile.hidden
          return false
        end
      end
    end
    true
  end

  def set_flag(pos)
    self[pos].flagged = !self[pos].flagged
  end
end




if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.render
end
