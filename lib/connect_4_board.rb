class Connect4Board
  attr_reader :next_color

  def initialize(row = 6, col = 7)
    @slots = Array.new(col) { Array.new(row) }
    @next_color = :red
    @last_slot = {}
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
    @last_slot[:row] = row
    @last_slot[:col] = col
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

  def four_aligned?(row = @last_slot[:row], col = @last_slot[:col])
    four_horizontally_aligned?(row, col) ||
      four_vertically_aligned?(row, col) ||
      four_diagonally_aligned?(row, col) ||
      four_anti_diagonally_aligned?(row, col)
  end

  private

  def four_horizontally_aligned?(row, col)
    color_nums = 1
    color = @slots[col][row]

    index = col + 1
    while index < @slots.size && @slots[index][row] == color
      color_nums += 1
      index += 1
    end

    index = col - 1
    while index >= 0 && @slots[index][row] == color
      color_nums += 1
      index -= 1
    end

    color_nums >= 4
  end

  def four_vertically_aligned?(row, col)
    color_nums = 1
    color = @slots[col][row]

    index = row + 1
    while index < @slots[col].size && @slots[col][index] == color
      color_nums += 1
      index += 1
    end

    index = row - 1
    while index >= 0 && @slots[col][index] == color
      color_nums += 1
      index -= 1
    end

    color_nums >= 4
  end

  def four_diagonally_aligned?(row, col)
    color_nums = 1
    color = @slots[col][row]

    row_index = row + 1
    col_index = col + 1
    while row_index < @slots.first.size && col_index < @slots.size &&
          @slots[col_index][row_index] == color
      color_nums += 1
      row_index += 1
      col_index += 1
    end

    row_index = row - 1
    col_index = col - 1
    while row_index >= 0 && col_index >= 0 &&
          @slots[col_index][row_index] == color
      color_nums += 1
      row_index -= 1
      col_index -= 1
    end

    color_nums >= 4
  end

  def four_anti_diagonally_aligned?(row, col)
    color_nums = 1
    color = @slots[col][row]

    row_index = row + 1
    col_index = col - 1
    while row_index < @slots.first.size && col_index >= 0 &&
          @slots[col_index][row_index] == color
      color_nums += 1
      row_index += 1
      col_index -= 1
    end

    row_index = row - 1
    col_index = col + 1
    while row_index >= 0 && col_index < @slots.size &&
          @slots[col_index][row_index] == color
      color_nums += 1
      row_index -= 1
      col_index += 1
    end

    color_nums >= 4
  end
end
