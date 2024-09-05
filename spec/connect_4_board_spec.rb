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

  describe '#put_mark' do
    subject(:marked_board) { described_class.new(8, 11) }

    context 'when 8x11 board is created' do
      it 'returns false if column index is below 0' do
        expect(marked_board.put_mark(3, -2)).to eq false
      end

      it 'returns false if column index is above 10' do
        expect(marked_board.put_mark(3, 11)).to eq false
      end

      it 'returns false if row index is below 0' do
        expect(marked_board.put_mark(-1, 5)).to eq false
      end

      it 'returns false if row index is above 7' do
        expect(marked_board.put_mark(15, 5)).to eq false
      end

      it 'returns true if column and row index are not out of range' do
        expect(marked_board.put_mark(3, 4)).to eq true
      end

      context 'when (5, 6) slot has nil value' do
        it 'makes (5, 6) slot colored by making its value the next color' do
          previous_color = marked_board.next_color
          expect { marked_board.put_mark(5, 6) }
            .to change { marked_board.slots[6][5] }.from(nil).to(previous_color)
        end

        it 'makes the next move color blue if it is red initially' do
          marked_board.instance_variable_set(:@next_color, :red)
          expect { marked_board.put_mark(5, 6) }
            .to change { marked_board.next_color }.from(:red).to(:blue)
        end

        it 'makes the next move color red if it is blue initially' do
          marked_board.instance_variable_set(:@next_color, :blue)
          expect { marked_board.put_mark(5, 6) }
            .to change { marked_board.next_color }.from(:blue).to(:red)
        end
      end

      context 'when (5, 6) slot has been colored previously' do
        before do
          slots = marked_board.instance_variable_get(:@slots)
          slots[6][5] = :blue
        end

        it 'does not change the color value of this slot' do
          expect { marked_board.put_mark(5, 6) }
            .not_to(change { marked_board.slots[6][5] })
        end

        it 'does not change the next move color' do
          expect { marked_board.put_mark(5, 6) }
            .not_to(change { marked_board.next_color })
        end
      end
    end
  end
end
