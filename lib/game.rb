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
        case piece
        when 'FU'
            correct_ans = player == 'black' ? [0, -1] : [0, 1]

            correct_move = correct_ans == get_pos_change(origin: origin, dest: dest) # valid_moves returns valid moves of pawn
            correct_move && path_clear(origin: origin, piece: piece, player: player, dest: dest)
        when 'KA'

        else
        end
    end

    def path_clear(origin: , piece: , player: , dest: )
        case piece
        when 'FU'
            piece_on_dest = @board[to_idx(square: dest)]
            piece_on_dest == '   ' || player != piece_on_dest.get_player
        when 'KA'
        else
        end
    end
end