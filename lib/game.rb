module GameHelper
    def to_idx(square:)
        col = square.to_s[0]
        row = square.to_s[1]
        (9 - col.to_i) + (row.to_i - 1)*9
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
end