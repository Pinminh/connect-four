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

  def drop_mark_at_col(col)
    column = @slots[col]

    return false if column.all? { |value| !value.nil? }

    row = 0
    column.each do |value|
      break if value.nil?

      row += 1
    end

    put_mark(row, col)
  end

  def all_colored?
    @slots.all? do |column|
      column.all? { |value| !value.nil? }
    end
  end
end
