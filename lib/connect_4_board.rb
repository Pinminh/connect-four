class Connect4Board
  attr_reader :next_color

  def initialize(row = 6, col = 7)
    @slots = Array.new(col) { Array.new(row) }
    @next_color = :red
  end

  def slots
    @slots.clone
  end

  def put_mark(row, col)
    return false if col.negative? || col >= @slots.size
    return false if row.negative? || row >= @slots.first.size
    return true unless @slots[col][row].nil?

    @slots[col][row] = @next_color
    @next_color = @next_color == :red ? :blue : :red
    true
  end
end
