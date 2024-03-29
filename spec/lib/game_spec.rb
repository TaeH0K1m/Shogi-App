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

        it 'gets player' do
          expect('+KI'.get_player).to eq 'black'
        end

        it 'does FU move' do
          game = Game.new
          board = game.setup()
          valid_move = game.valid_move?(origin: 27, piece: 'FU', player: 'black', dest: 26)

          expect(valid_move).to eq true
        end

        it 'does FU not move' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 29, piece: 'KE', player: 'black', dest: 26)
          valid_move = game.valid_move?(origin: 27, piece: 'FU', player: 'black', dest: 26)

          expect(valid_move).to eq false
        end

        it 'does KY move' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 97, piece: 'FU', player: 'black', dest: 86)
          # game.print_board
          valid_move = game.valid_move?(origin: 99, piece: 'KY', player: 'black', dest: 93)

          expect(valid_move).to eq true
        end

        it 'does KY not move' do
          game = Game.new
          board = game.setup()
          valid_move = game.valid_move?(origin: 99, piece: 'KY', player: 'black', dest: 97)

          expect(valid_move).to eq false
        end

        it 'does KY not move (not on the same line)' do
          game = Game.new
          board = game.setup()
          valid_move = game.valid_move?(origin: 99, piece: 'KY', player: 'black', dest: 66)

          expect(valid_move).to eq false
        end

        it 'does KE move' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 97, piece: 'FU', player: 'black', dest: 86)
          # game.print_board
          valid_move = game.valid_move?(origin: 89, piece: 'KE', player: 'black', dest: 97)

          expect(valid_move).to eq true
        end

        it 'does KE not move' do
          game = Game.new
          board = game.setup()
          valid_move = game.valid_move?(origin: 89, piece: 'KE', player: 'black', dest: 77)

          expect(valid_move).to eq false
        end

        [63, 53, 43, 65, 45].each do |pos|
          it "does GI move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 79, piece: 'GI', player: 'black', dest: 54)
            # game.print_board
            valid_move = game.valid_move?(origin: 54, piece: 'GI', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [64, 44, 55, 56, 51].each do |pos|
          it "does GI not move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 79, piece: 'GI', player: 'black', dest: 54)
            # game.print_board
            valid_move = game.valid_move?(origin: 54, piece: 'GI', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        [64, 54, 44, 65, 45, 56].each do |pos|
          it 'KI moves' do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 69, piece: 'KI', player: 'black', dest: 55)
            valid_move = game.valid_move?(origin: 55, piece: 'KI', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [66, 46].each do |pos|
          it 'KI does not move' do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 69, piece: 'KI', player: 'black', dest: 55)
            valid_move = game.valid_move?(origin: 55, piece: 'KI', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        [45, 34, 65, 74].each do |pos|
          it "does KA move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 88, piece: 'KA', player: 'black', dest: 56)
            # game.print_board
            valid_move = game.valid_move?(origin: 56, piece: 'KA', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [45, 36, 65, 76].each do |pos|
          it "does KA move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 88, piece: 'KA', player: 'black', dest: 54)
            # game.print_board
            valid_move = game.valid_move?(origin: 54, piece: 'KA', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [47, 67, 78, 38, 92, 82, 17, 12].each do |pos|
          it "does KA not move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 88, piece: 'KA', player: 'black', dest: 56)
            # game.print_board
            valid_move = game.valid_move?(origin: 56, piece: 'KA', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        # Rook (HI)
        [53, 56, 54, 65, 75, 85, 95, 45, 35, 25, 15].each do |pos|
          it "does HI move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 28, piece: 'HI', player: 'black', dest: 55)
            # game.print_board
            valid_move = game.valid_move?(origin: 55, piece: 'HI', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [52, 51, 57, 58, 59].each do |pos|
          it "does HI not move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 28, piece: 'HI', player: 'black', dest: 55)
            # game.print_board
            valid_move = game.valid_move?(origin: 55, piece: 'HI', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        [88, 98].each do |pos|
          it "does HI not move #{pos}" do
            game = Game.new
            board = game.setup()
            # game.print_board
            valid_move = game.valid_move?(origin: 28, piece: 'HI', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        # King (OU)
        [64, 54, 44, 45, 46, 56, 66, 65].each do |pos|
          it "does OU move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 59, piece: 'OU', player: 'black', dest: 55)
            # game.print_board
            valid_move = game.valid_move?(origin: 55, piece: 'OU', player: 'black', dest: pos)

            expect(valid_move).to eq true
          end
        end

        [67, 57, 47, 69, 49].each do |pos|
          it "does OU not move #{pos}" do
            game = Game.new
            board = game.setup()
            game.move_piece(origin: 59, piece: 'OU', player: 'black', dest: 58)
            # game.print_board
            valid_move = game.valid_move?(origin: 58, piece: 'OU', player: 'black', dest: pos)

            expect(valid_move).to eq false
          end
        end

        it 'moves' do
          game = Game.new
          board = game.setup()

          is_moved = game.move(origin: 57, piece: 'FU', player: 'black', dest: 56)

          expect(is_moved).to eq true
        end

        it 'captures' do
          game = Game.new
          board = game.setup()
          game.move_piece(origin: 87, piece: 'FU', player: 'black', dest: 84)

          game.move(origin: 84, piece: 'FU', player: 'black', dest: 83)
          # p game.hands

          expect(game.hands[:black][:FU]).to eq 1
        end

        context 'when dropping' do
         # in hand can drop
         # not in hand and can't drop
         # in hand but destination doesn't allow
          # destination is occuppied
          # pawn is in last row
          # horse is in 2nd last row
          let(:game) { Game.new }
          let(:board) { game.setup() }

          it 'is in hand' do
            board
            game.move_piece(origin: 87, piece: 'FU', player: 'black', dest: 84)

            game.move(origin: 84, piece: 'FU', player: 'black', dest: 83)

            is_dropped = game.drop(origin: '00', piece: 'FU', player: 'black', dest: 55)

            expect(is_dropped).to eq true
            expect(game.hands[:black][:FU]).to eq 0
          end

          it 'is not in hand' do
            board
            is_dropped = game.drop(origin: '00', piece: 'FU', player: 'black', dest: 55)

            expect(is_dropped).to eq false
          end

          it 'is in hand but destination is occuppied' do
            board
            game.move_piece(origin: 87, piece: 'FU', player: 'black', dest: 84)

            game.move(origin: 84, piece: 'FU', player: 'black', dest: 83)

            is_dropped = game.drop(origin: '00', piece: 'FU', player: 'black', dest: 51)
            expect(is_dropped).to eq false
          end

          it 'pawn dropping on last row' do
            board
            game.move_piece(origin: 31, piece: 'GI', player: 'white', dest: 42)
            game.hands[:black][:FU] += 1

            is_dropped = game.drop(origin: '00', piece: 'FU', player: 'black', dest: 31)
            expect(is_dropped).to eq false
          end

          it 'Knight dropping on 2nd last row' do
            board
            game.hands[:black][:KE] += 1

            is_dropped = game.drop(origin: '00', piece: 'KE', player: 'black', dest: 32)
            expect(is_dropped).to eq false
          end
        end

        context 'when promoting' do
          let(:game) { Game.new }

          # TO (Promoted Pawn), NY (P-Lance), NK (P-Knight), NG (P-Silver), RY (Promoted Rock), UM (Promoted Bishop)
          [['FU', 'TO'], ['KY', 'NY'], ['KE', 'NK'], ['GI', 'NG'], ['KA', 'UM'], ['HI', 'RY']].each do |piece, promoted_piece|

            it "checks if the #{piece} can promote" do
              # from outside to inside
              expect(game.can_promote?(origin: 56, player: 'black', dest: 52)).to eq true

              # from inside to outside
              expect(game.can_promote?(origin: 52, player: 'black', dest: 56)).to eq true

              # within inside
              expect(game.can_promote?(origin: 52, player: 'black', dest: 51)).to eq true
            end

            it "checks if the #{piece} can not promote" do
              expect(game.can_promote?(origin: 56, player: 'black', dest: 59)).to eq false
            end

            it "promotes #{piece} to #{promoted_piece}" do
              game.board[to_idx(square: 54)] = "+#{piece}"
              # game.print_board
              game.move_piece(origin: 54, piece: piece, player: 'black', dest: 53)
              # game.print_board
              expect(game.board[to_idx(square: 53)]).to eq "+#{promoted_piece}"
            end
          end      

          %w[ TO NY NK NG ].each do |piece|
            [64, 54, 44, 65, 45, 56].each do |pos|
              it "#{piece} moves" do
                board = game.setup()
                game.move_piece(origin: 69, piece: piece, player: 'black', dest: 55)
                valid_move = game.valid_move?(origin: 55, piece: piece, player: 'black', dest: pos)

                expect(valid_move).to eq true
              end
            end

            [66, 46].each do |pos|
              it "#{piece} does not moves" do
                board = game.setup()
                game.move_piece(origin: 69, piece: piece, player: 'black', dest: 55)
                valid_move = game.valid_move?(origin: 55, piece: piece, player: 'black', dest: pos)
  
                expect(valid_move).to eq false
              end
            end
          end 

          # %w[ UM RY ].each do |piece|
          #   it "#{piece} moves" do

          #   end
          # end

        end
    end
 end