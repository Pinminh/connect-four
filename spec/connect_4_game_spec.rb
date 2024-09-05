require_relative '../lib/connect_4_game'

describe Connect4Game do
  subject(:game) { described_class.new(8, 10) }

  describe '#input_next_move' do
    context 'when player enters 3 invalid inputs follows 1 valid input' do
      before do
        invalid_input1 = '@a'
        invalid_input2 = '100'
        invalid_input3 = '1b'
        valid_input = '4'
        allow(game).to receive(:gets).and_return(
          invalid_input1, invalid_input2, invalid_input3, valid_input
        )
      end

      it 'prints 3 errors responding to the first 3 inputs' do
        expect(game).to receive(:puts).with(/^Error:/).exactly(3).times
        game.input_next_move
      end

      it 'returns the valid position 4' do
        expect(game.input_next_move).to eq(4)
      end
    end
  end
end
