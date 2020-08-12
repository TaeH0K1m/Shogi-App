require 'game'

include GameHelper

describe "Game" do
    context "new" do

       it "initializes the empty board" do
            game = Game.new
            board = game.board
            expect(board).to eq %w[-]*80
       end

       it "sets up the board" do
            game = Game.new
            board = game.setup()
            expected_board = [
                '-KY', '-KE', '-GI', '-KI', '-OU', '-KI', '-GI', '-KE', '-KY',
                '   ', '-HI', '   ', '   ', '   ', '   ', '   ', '-KA', '   ',
                '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU',
                '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ',
                '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ',
                '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ',
                '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU',
                '   ', '+KA', '   ', '   ', '   ', '   ', '   ', '+HI', '   ',
                '+KY', '+KE', '+GI', '+KI', '+OU', '+KI', '+GI', '+KE', '+KY'
            ]
            expect(board).to eq expected_board

       end

       it "is black's turn (first move)" do
            game = Game.new
            board = game.setup()

            expect(game.turn).to eq 'black'
       end

       it "checks if the pieces are at the origin 1" do
            game = Game.new
            board = game.setup()
            valid_position = game.check_position(origin: 27, piece: 'FU', player: 'black')

            expect(valid_position).to eq true
       end

       it "checks if the pieces are at the origin 2" do
            game = Game.new
            board = game.setup()
            valid_position = game.check_position(origin: 71, piece: 'GI', player: 'white')

            expect(valid_position).to eq true
        end

        it "checks if the pieces are at the origin 3" do
            game = Game.new
            board = game.setup()
            valid_position = game.check_position(origin: 59, piece: 'OU', player: 'black') # renane check_position -> valid_position?

            expect(valid_position).to eq true
        end

        it 'moves piece' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 29, piece: 'KE', player: 'black', dest: 26)
          hardcopy_board = [
            '-KY', '-KE', '-GI', '-KI', '-OU', '-KI', '-GI', '-KE', '-KY',
            '   ', '-HI', '   ', '   ', '   ', '   ', '   ', '-KA', '   ',
            '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU', '-FU',
            '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ',
            '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ', '   ',
            '   ', '   ', '   ', '   ', '   ', '   ', '   ', '+KE', '   ',
            '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU', '+FU',
            '   ', '+KA', '   ', '   ', '   ', '   ', '   ', '+HI', '   ',
            '+KY', '+KE', '+GI', '+KI', '+OU', '+KI', '+GI', '   ', '+KY'
        ]
          expect(board).to eq hardcopy_board
        end

        it 'does it move' do
          game = Game.new
          board = game.setup()
          valid_move = game.valid_move?(origin: 27, piece: 'FU', player: 'black', dest: 26)

          expect(valid_move).to eq true
        end

        it 'does it move' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 29, piece: 'KE', player: 'black', dest: 26)
          valid_move = game.valid_move?(origin: 27, piece: 'FU', player: 'black', dest: 26)

          expect(valid_move).to eq false
        end

        it 'gets player' do
         expect('+KI'.get_player).to eq 'black'
        end
    #    it "test 2" do
    #         game = Game.new
    #         game.move_piece(square: '99', piece: 'FU')
    #         expect(game.is_occupy(square: '99', piece: 'FU')).to eq true
    #    end

    #    it "test 3" do
    #         game = Game.new
    #         expect(Game.to_idx(square: 91)).to eq 0
    #    end

    #    it "test 4" do
    #         game = Game.new
    #         expect(Game.to_idx(square: 76)).to eq 47
    #    end

    #     it "test 5" do
    #         game = Game.new
    #         expect(Game.to_idx(square: 24)).to eq 34
    #     end

    #     it "test 6" do
    #         game = Game.new
    #         expect(game.move_piece(square: 91, piece: 'FU')).to eq true
    #     end

    end
 end