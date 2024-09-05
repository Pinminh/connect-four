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

  describe '#all_colored?' do
    subject(:uncolored_board) { described_class.new }

    it 'returns false if some slots in the board are left with nil value' do
      expect(uncolored_board).not_to be_all_colored
    end

    subject(:colored_board) { described_class.new }

    it 'returns true if all slots in the board are filled with color value' do
      slots = colored_board.instance_variable_get(:@slots)
      slots.each { |column| column.fill(:blue) }
      expect(colored_board).to be_all_colored
    end
  end

  describe '#drop_mark_at_col' do
    subject(:drop_board) { described_class.new(8, 12) }
    let(:column) { drop_board.instance_variable_get(:@slots)[4] }

    context 'when the column 4 is full' do
      before do
        column.fill(:blue)
      end

      it 'do not change the slot value' do
        expect { drop_board.drop_mark_at_col(4) }.not_to(change { column })
      end

      it 'do not change the next color' do
        expect { drop_board.drop_mark_at_col(4) }.not_to(change { drop_board.next_color })
      end
    end

    context 'when the column 4 is not full' do
      it 'adds next color at the bottom of the column' do
        expect { drop_board.drop_mark_at_col(4) }
          .to change { column[0] }.from(nil).to(drop_board.next_color)
      end

      it 'flips the next color' do
        expect { drop_board.drop_mark_at_col(4) }
          .to change { drop_board.next_color }.from(:red).to(:blue)
      end
    end
  end
end
