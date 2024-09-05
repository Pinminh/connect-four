require_relative '../lib/connect_4_board'

describe Connect4Board do
  describe '#initialize' do
    matcher :have_size_of do |given_size|
      match do |actual|
        given_size == actual.size
      end
    end
    
    context 'when no arguments are passed' do
      subject(:default_board) { described_class.new }

      it 'creates 6x7 board' do
        expect(default_board.slots.size).to eq(7)
        expect(default_board.slots).to all have_size_of(6)
      end
    end

    context 'when arguments (10, 20) are passed' do
      subject(:customized_board) { described_class.new(10, 20) }

      it 'creates 10x20 board' do
        expect(customized_board.slots.size).to eq(20)
        expect(customized_board.slots).to all have_size_of(10)
      end
    end

    context 'after the board is created' do
      subject(:created_board) { described_class.new }

      it 'populates the slots with nil value initially' do
        expect(created_board.slots).to all all be_nil
      end

      it 'makes the first move have red color' do
        expect(created_board.next_color).to eq(:red)
      end
    end
  end
end