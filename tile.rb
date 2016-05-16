

class Tile
  attr_accessor :value , :hidden, :flagged

  def initialize(value, hidden = true)
    @value = value
    @hidden = hidden
    @flagged = false
  end


end
