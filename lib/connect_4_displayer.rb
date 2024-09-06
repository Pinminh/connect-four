require 'io/console'
require_relative 'connect_4_board'

class Connect4Displayer
  NIL_SYMB = "\u{1F518}".freeze
  RED_SYMB = "\u{1F534}".freeze
  BLE_SYMB = "\u{1F535}".freeze
  SYMB_WIDTH = 3
  SLOT_WIDTH = 4

  def initialize(board = Connect4Board.new)
    @board = board
  end

  def value_to_symbol(value)
    return RED_SYMB if value == :red
    return BLE_SYMB if value == :blue

    NIL_SYMB
  end

  def intro_message
    clear_terminal

    message = 'The game is all about: drop color coins, ' \
              'get a row of coins, or a coloumn of coins, ' \
              'or a diagonal of coins, and we win.'
    message += "\nPress any key to continue..."

    puts "\e[33m#{message}\e[0m"
    $stdin.getch
  end

  def winning_message(result)
    show_board

    message = 'An unknown result has emerged!'
    message = 'The game is tie!' if result == :tie
    message = 'The winner is red-player!' if result == :red
    message = 'The winner is blue-player!' if result == :blue

    puts "\e[32m#{message}\e[0m"
  end

  def show_slot_order
    slots = @board.slots
    0.upto(slots.size - 1) do |col|
      print (col + 1).to_s.center(SLOT_WIDTH)
    end
    puts
  end

  def show_board
    clear_terminal
    slots = @board.slots

    (slots.first.size - 1).downto(0) do |row|
      0.upto(slots.size - 1) do |col|
        print value_to_symbol(slots[col][row]).center(SYMB_WIDTH)
      end
      puts
    end

    show_slot_order
  end

  def show_error(message)
    show_board

    puts "\e[31m#{message}\e[0m"
  end

  def show_prompt(message)
    print "\e[33m#{message}\e[0m"
  end

  def clear_terminal
    system('cls') || system('clear')
  end
end
