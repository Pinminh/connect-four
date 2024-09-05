require_relative 'connect_4_board'

class Connect4Game
  def initialize(row = 6, col = 7)
    @board = Connect4Board.new(row, col)
  end

  def input_next_move
    input = nil
    loop do
      print "#{@board.next_color}-player enter position (1 to #{@board.slots.size}): "
      input = convert_string_to_position(gets.chomp)

      break if valid_position?(input)
    end
    input
  end

  private

  def convert_string_to_position(string)
    return nil unless string.match?(/^\d+$/)

    string.to_i
  end

  def valid_position?(position)
    if position.nil?
      puts 'Error: please enter a recognizable positive integer!'
      return false
    end

    if position.zero? || position > @board.slots.size
      puts "Error: position must be between 1 and #{@board.slots.size} inclusively!"
      return false
    end

    column = @board.slots[position - 1]
    if column.all? { |slot| !slot.nil? }
      puts 'Error: this column is full, please choose another one!'
      return false
    end

    true
  end
end
