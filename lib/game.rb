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
end

class Game
    attr_accessor :board, :turn

    def initialize
        @board = %w[-]*80
    end

    def setup
        @turn = 'black'
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

    def move_piece(origin: , piece: , player: , dest: )

        @board[to_idx(square: origin)] = '   '

        turn = player == 'black' ? '+' : '-'
        @board[to_idx(square: dest)] = "#{turn}#{piece}"
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
        else
        end
    end

    def path_clear(origin: , piece: , player: , dest: )
        dx = 0
        dy = 1

        empty_square = '   '
        piece_on_dest = @board[to_idx(square: dest)]

        case piece
        when 'FU'
            piece_on_dest == empty_square || player != piece_on_dest.get_player
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
            true
        else
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