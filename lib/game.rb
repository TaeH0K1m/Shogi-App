module GameHelper
    def to_idx(square:)
        col = square.to_s[0]
        row = square.to_s[1]
        (9 - col.to_i) + (row.to_i - 1)*9
    end

    def get_pos_change(origin: , dest: )
        origin_arr = [origin.to_s[0].to_i, origin.to_s[1].to_i]
        dest_arr = [dest.to_s[0].to_i, dest.to_s[1].to_i]
        dx = dest_arr[0] - origin_arr[0]
        dy = dest_arr[1] - origin_arr[1]
        [dx, dy]
    end

    def get_player
        self[0] == '+' ? 'black' : 'white'
    end

    def get_piece
        self[1..2]
    end
end

class Game
    attr_accessor :board, :turn, :hands

    BLACK_TERRITORY = [*54..80]
    WHITE_TERRITORY = [*0..26]
    PROMOTION = {
        'FU' => 'TO',
        'KA' => 'UM',
        'HI' => 'RY',
        'KY' => 'NY',
        'KE' => 'NK',
        'GI' => 'NG'
    }

    def initialize
        @turn = 'black'
        @board = %w[-]*80
        @hands = {
            black: {
                OU: 0,
                HI: 0,
                KA: 0,
                KI: 0,
                GI: 0,
                KE: 0,
                KY: 0,
                FU: 0
            },
            white: {
                OU: 0,
                HI: 0,
                KA: 0,
                KI: 0,
                GI: 0,
                KE: 0,
                KY: 0,
                FU: 0
            },
        }
    end

    def setup
        @board = [
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
    end

    def check_position(origin:, piece:, player:)
        turn = player == 'black' ? '+' : '-'
        board[to_idx(square: origin)] == "#{turn}#{piece}"
    end

    def move(origin: , piece: , player: , dest: )
        is_success = valid_move?(origin: origin, piece: piece, player: player, dest: dest)
        piece_on_dest = @board[to_idx(square: dest)]

        if is_success
            capture_piece(piece: piece_on_dest) if player != piece_on_dest.get_player && piece_on_dest != '   '
            move_piece(origin: origin, piece: piece, player: player, dest: dest)
        end

        is_success
    end

    def drop(origin: , piece: , player: , dest: )
        if check_player_hand(player: player, piece: piece) &&
             valid_drop?(origin: origin, piece: piece, player: player, dest: dest)

            @hands[player.to_sym][piece.to_sym] -= 1
            move_piece(origin: origin, piece: piece, player: player, dest: dest)
            return true
        end
        return false
    end

    def check_player_hand(player:, piece:)
        @hands[player.to_sym][piece.to_sym] > 0
    end

    def valid_drop?(origin:, player:, piece:, dest:)
        piece_on_dest = @board[to_idx(square: dest)]
        idx = to_idx(square: dest)

        is_dest_empty = piece_on_dest == '   ' if origin == '00'

        last_row_legal =
            case piece
            when 'FU'
                idx > 9
            when 'KE'
                idx > 18
            else
                true
            end
        return is_dest_empty && last_row_legal
    end

    def capture_piece(piece:)
        player = piece.get_player.to_sym
        piece = piece.get_piece.to_sym

        if player == :black
            @hands[:white][piece] += 1
        else
            @hands[:black][piece] += 1
        end
    end

    def move_piece(origin: , piece: , player: , dest: )
        if origin != '00'
            @board[to_idx(square: origin)] = '   '
        end

        turn = player == 'black' ? '+' : '-'

        if can_promote?(origin: origin, player: player, dest: dest)
            # puts 'Do you want to promote? (y/n)'
            # answer = gets
            answer = 'y'
            piece = answer == 'y' ? PROMOTION[piece] : piece
        end

        @board[to_idx(square: dest)] = "#{turn}#{piece}"
    end

    def can_promote?(origin:, player:, dest:)
        if player == 'black'
            WHITE_TERRITORY.include?(to_idx(square: origin)) || WHITE_TERRITORY.include?(to_idx(square: dest))
        else # 'whiwte'
            BLACK_TERRITORY.include?(to_idx(square: origin)) || BLACK_TERRITORY.include?(to_idx(square: dest))
        end
    end

    def valid_move?(origin: , piece: , player: , dest: )
        # check if piece can make that move
        # check if path is clear
        legal_move(origin: origin, piece: piece, player: player, dest: dest) &&
        path_clear(origin: origin, piece: piece, player: player, dest: dest)
    end

    def legal_move(origin: , piece: , player: , dest: )
        pos_change = get_pos_change(origin: origin, dest: dest)
        dx = 0
        dy = 1
        piece_on_dest = @board[to_idx(square: dest)]

        # Check no movements
        return false if origin == dest

        case piece
        when 'FU'
            if player == 'black'
                pos_change[dx] == 0 &&
                pos_change[dy] == -1
            else # white
                pos_change[dx] == 0 &&
                pos_change[dy] == 1
            end
        when 'KY'
            if player == 'black'
                pos_change[dx] == 0 &&
                pos_change[dy] < 0
            else # white
                pos_change[dx] == 0 &&
                pos_change[dy] > 0
            end
        when 'KE'
            if player == 'black'
                (pos_change[dx] == 1 || pos_change[dx] == -1 ) &&
                pos_change[dy] == -2
            else # white
                (pos_change[dx] == 1 || pos_change[dx] == -1 ) &&
                pos_change[dy] == 2
            end
        when 'GI'
            valid_pos = [
                { x: -1, y: -1 },
                { x:  0, y: -1 },
                { x:  1, y: -1 },
                { x: -1, y: 1 },
                { x:  1, y: 1 },
            ]

            if player == 'black'
                valid_pos.include?({ x: pos_change[dx], y: pos_change[dy] })
            else # white
                valid_pos.include?({ x: -pos_change[dx], y: -pos_change[dy] })
            end
        when 'KI'
            valid_pos = [
                { x:  1, y: -1 }, # top left
                { x: -1, y: -1 }, # top right
                { x:  0, y: -1 }, # top middle
                { x:  1, y:  0 }, # middle left
                { x: -1, y:  0 }, # middle right
                { x:  0, y:  1 }, # bottom middle
            ]

            if player == 'black'
                valid_pos.include?({ x: pos_change[dx], y: pos_change[dy] })
            else # white
                valid_pos.include?({ x: -pos_change[dx], y: -pos_change[dy] })
            end
        when 'KA'
            pos_change[dx].abs == pos_change[dy].abs
        when 'HI'
            pos_change[dx].zero? ^ pos_change[dy].zero?
        when 'OU'
            pos_change[dx].abs <= 1 &&
            pos_change[dy].abs <= 1 &&
            !(pos_change[dx].abs + pos_change[dy].abs).zero?
        end
    end

    def path_clear(origin: , piece: , player: , dest: )
        dx = 0
        dy = 1

        empty_square = '   '
        piece_on_dest = @board[to_idx(square: dest)]

        case piece
        when 'FU', 'KE', 'GI', 'KI', 'OU'
            piece_on_dest == empty_square ||
            player != piece_on_dest.get_player
        when 'KY'
            pos_change = get_pos_change(origin: origin, dest: dest)
            pos_change[dy].abs.times { |index|

                if player == 'black'
                    y_pos_diff = (index+1) * -1
                else # white
                    y_pos_diff = (index+1)
                end

                x_pos = origin.to_s[dx]
                y_pos = origin.to_s[dy].to_i + y_pos_diff

                piece_on_square = @board[to_idx(square: "#{x_pos}#{y_pos}".to_i)]

                if index == pos_change[dy].abs - 1 # checking if the squre is destination
                    return piece_on_dest == empty_square || player != piece_on_dest.get_player
                else
                    return false if piece_on_square != empty_square
                end
            }
        when 'KA'
            pos_change = get_pos_change(origin: origin, dest: dest)
            # p "pos_change: #{pos_change}"

            # get_direction
            step = pos_change.map { |pos| pos/pos.abs }
            current_pos = [origin.to_s[dx].to_i, origin.to_s[dy].to_i]

            pos_change[dx].abs.times { |index|
                current_pos = [(step[dx] + current_pos[dx]),  (step[dy] + current_pos[dy])]
                x_pos = current_pos[dx]
                y_pos = current_pos[dy]
                piece_on_square = @board[to_idx(square: "#{x_pos}#{y_pos}".to_i)]

                if current_pos.join().to_i == dest
                    return piece_on_dest == empty_square || player != piece_on_dest.get_player
                else
                    return false if piece_on_square != empty_square
                end
            }
        when 'HI'
            # move_x = pos_change[dx]
            # move_y = pos_change[dy]
            pos_change = get_pos_change(origin: origin, dest: dest)

            target = pos_change[dx].zero? ? pos_change[dy] : pos_change[dx]
            step = pos_change[dx].zero? ? [0, pos_change[dy]/pos_change[dy].abs] : [pos_change[dx]/pos_change[dx].abs, 0]

            current_pos = [origin.to_s[dx].to_i, origin.to_s[dy].to_i]

            target.abs.times { |index|
                current_pos = [(step[dx] + current_pos[dx]),  (step[dy] + current_pos[dy])]
                x_pos = current_pos[dx]
                y_pos = current_pos[dy]
                piece_on_square = @board[to_idx(square: "#{x_pos}#{y_pos}".to_i)]

                if current_pos.join().to_i == dest
                    return piece_on_dest == empty_square || player != piece_on_dest.get_player
                else
                    return false if piece_on_square != empty_square
                end
            }
        end
    end

    def print_board
        @board.each_with_index do |cell, index|
            puts ' ' if index % 9 == 0
            print cell + ' '
        end
        puts ' '
    end
end