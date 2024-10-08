require_relative '../lib/connect_4_game'

describe Connect4Game do
  before do
    allow($stdin).to receive(:getch).and_return(nil)
  end

  describe '#input_next_move' do
    subject(:game) { described_class.new(8, 10) }
    let(:displayer) { game.instance_variable_get(:@displayer) }

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
        expect(displayer).to receive(:show_error).exactly(3).times
        game.input_next_move
      end

      it 'returns the valid position 4' do
        expect(game.input_next_move).to eq(4)
      end
    end
  end

  describe '#game_over?' do
    subject(:game_end) { described_class.new(4, 4) }

    context 'when there is a all-colored board' do
      before do
        slots = [%i[red red red blue],
                 %i[red blue red red],
                 %i[blue red red blue],
                 %i[red red blue blue]]

        board = game_end.instance_variable_get(:@board)
        board.instance_variable_set(:@slots, slots)
        board.instance_variable_set(:@last_slot, { row: 1, col: 1 })
      end

      it 'returns true since the game can not proceed anymore' do
        expect(game_end).to be_game_over
      end
    end

    context 'when there is a four' do
      before do
        slots = [%i[red red red red],
                 [:blue, :red, nil, nil],
                 [:blue, :blue, nil, nil],
                 [:red, :blue, :blue, nil]]

        board = game_end.instance_variable_get(:@board)
        board.instance_variable_set(:@slots, slots)
        board.instance_variable_set(:@last_slot, { row: 3, col: 0 })
      end

      it 'returns true since there is a winning player' do
        expect(game_end).to be_game_over
      end
    end

    context 'when the board is not all-colored and there are no fours' do
      before do
        slots = [[:red, :blue, nil, nil],
                 [:blue, :red, :blue, nil],
                 [:red, :red, nil, nil],
                 [:blue, nil, nil, nil]]

        board = game_end.instance_variable_get(:@board)
        board.instance_variable_set(:@slots, slots)
        board.instance_variable_set(:@last_slot, { row: 1, col: 2 })
      end

      it 'returns false since the game is neither tie nor win' do
        expect(game_end).not_to be_game_over
      end
    end
  end

  describe '#play_game' do
    subject(:game_played) { described_class.new(4, 4) }
    let(:board_played) { game_played.instance_variable_get(:@board) }

    context 'red-player goes 1, 2, 3, 4 while blue-player goes 1, 1, 1' do
      before do
        allow(game_played).to receive(:input_next_move)
          .and_return(1, 1, 2, 1, 3, 1, 4)
      end

      it 'inputs moves for 7 times' do
        expect(game_played).to receive(:input_next_move).exactly(7).times
        game_played.play_game
      end

      it 'declares that red-player is the winner' do
        expect(game_played).to receive(:winning_result).and_return(:red)
        game_played.play_game
      end
    end

    context 'red-player and blue-player play so that no one win' do
      before do
        allow(game_played).to receive(:input_next_move)
          .and_return(3, 2, 1, 4, 2, 3, 4, 1, 1, 2, 3, 4, 1, 2, 3, 4)
      end

      it 'inputs moves for 16 times' do
        expect(game_played).to receive(:input_next_move).exactly(16).times
        game_played.play_game
      end

      it 'declares that the game is tie' do
        expect(game_played).to receive(:winning_result).and_return(:tie)
        game_played.play_game
      end

      it 'makes the board all-colored' do
        game_played.play_game
        expect(board_played).to be_all_colored
      end
    end
  end
end
