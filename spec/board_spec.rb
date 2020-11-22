require 'colorize'
require_relative '../lib/modules/display'
require_relative '../lib/modules/setup_board_variables'
require_relative '../lib/modules/adjacency_list_generator'
require_relative '../lib/modules/input_validator'
require_relative '../lib/modules/move_validator'
require_relative '../lib/modules/move_disambiguator'
require_relative '../lib/modules/castle_manager'
require_relative '../lib/modules/checkmate_manager'
require_relative '../lib/board'
require_relative '../lib/empty_square.rb'
require_relative '../lib/player'
require_relative '../lib/rook'
require_relative '../lib/knight'
require_relative '../lib/bishop'
require_relative '../lib/king'
require_relative '../lib/queen'
require_relative '../lib/pawn'

describe Board do
  subject(:board) { described_class.new }

  describe '#initialize' do
    context 'when no board state is give' do
      it 'makes the initial board' do
        initial_board = board.make_initial_board
        expect(board.instance_variable_get(:@squares)).to eq(initial_board)
      end
    end
  end

  describe '#duplicate_board' do
    context 'when current board state is passed in' do
      it 'populates a new board with new piece objects' do
        current_board = board.squares
        new_board = board.duplicate_board(current_board)
        expect(new_board).not_to eq(current_board)
      end
    end
  end

  describe '#find_piece' do
    context 'when move is a castle move' do
      it 'returns the white or black king' do
        move = '0-0'
        white_king = board.squares[7][4]
        player_color = :white
        piece_type = King
        expect(board.find_piece(move, player_color, piece_type)).to eq(white_king)
      end
    end

    context 'when move is not a castle move' do
      it 'finds the relevant white or black piece' do
        move = 'Nc3'
        player_color = :white
        piece_type = Knight
        white_knight = board.squares[7][1]
        allow(board).to receive(:white_pieces_that_go_to_dest).and_return([white_knight])
        expect(board.find_piece(move, player_color, piece_type)).to eq(white_knight)
      end
    end
  end

  describe '#find_white_piece' do
    context 'when move is a pawn attack' do
      it 'finds which pawn is attacking' do
        move = 'axb3'
        piece_type = Pawn
        attacking_pawn = board.squares[6][0]
        allow(board).to receive(:white_pieces_that_go_to_dest).and_return([attacking_pawn])
        expect(board.find_white_piece(move, piece_type)).to eq(attacking_pawn)
      end
    end

    context 'when move is not a pawn attack' do
      it 'returns the found piece' do
        move = 'Nf3'
        piece_type = Knight
        white_knight = board.squares[7][6]
        allow(board).to receive(:white_pieces_that_go_to_dest).and_return([white_knight])
        expect(board.find_white_piece(move, piece_type)).to eq(white_knight)
      end
    end
  end
end