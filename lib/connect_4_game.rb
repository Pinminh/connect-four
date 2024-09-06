require_relative 'connect_4_board'
require_relative 'connect_4_displayer'

class Connect4Game
  def initialize(row = 6, col = 7)
    @board = Connect4Board.new(row, col)
    @displayer = Connect4Displayer.new(@board)
  end

  def input_next_move
    input = nil
    loop do
      @displayer.show_prompt "#{@board.next_color}-player enter position (1 to #{@board.slots.size}): "
      input = convert_string_to_position(gets.chomp)

      break if valid_position?(input)
    end
    input
  end

  def game_over?
    @board.all_colored? || @board.four_aligned?
  end

  def winning_result
    return :tie if @board.all_colored?

    @board.next_color == :red ? :blue : :red
  end

  def play_game
    @displayer.intro_message
    loop do
      @displayer.show_board

      position = input_next_move
      @board.drop_mark_at_col(position - 1)

      break if game_over?
    end
    @displayer.winning_message(winning_result)
  end

  private

  def convert_string_to_position(string)
    return nil unless string.match?(/^\d+$/)

    string.to_i
  end

  def valid_position?(position)
    if position.nil?
      @displayer.show_error 'Error: please enter a recognizable positive integer!'
      return false
    end

    if position.zero? || position > @board.slots.size
      @displayer.show_error "Error: position must be between 1 and #{@board.slots.size} inclusively!"
      return false
    end

    column = @board.slots[position - 1]
    if column.all? { |slot| !slot.nil? }
      @displayer.show_error 'Error: this column is full, please choose another one!'
      return false
    end

    true
  end
end
