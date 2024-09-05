class Connect4Board
  attr_reader :next_color
  
  def initialize(row = 6, col = 7)
    @slots = Array.new(col) { Array.new(row) }
    @next_color = :red
  end

  def slots
    @slots.clone
  end
end