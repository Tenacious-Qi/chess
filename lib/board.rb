# frozen_string_literal: true

class Board
  include Display
  include MoveValidator
  include SetupBoardVariables
  attr_reader :start_row, :start_column, :piece, :piece_type, :disambiguated
  
  def initialize(squares = make_initial_board)
    @squares = squares
    @start_column = nil
    @dest_column = nil
    @start_row = nil
    @dest_row = nil
    @piece = nil
    @piece_type = nil
    @piece_prefix = nil
    @disambiguated = false
  end

  def make_initial_board
    @squares = [
      black_row,
      # Array.new(8) { |c| Pawn.new(2, [1, c]) },
      Array.new(8) { ' ' },
      Array.new(8) { ' ' },
      Array.new(8) { ' ' },
      Array.new(8) { ' ' },
      Array.new(8) { ' ' },
      Array.new(8) { ' ' },
      # Array.new(8) { |c| Pawn.new(1, [6, c]) },
      white_row
    ]
  end

  def black_row
    [
      Rook.new(2, [0, 0]), Knight.new(2, [0, 1]), Bishop.new(2, [0, 2]),
      Queen.new(2, [0, 3]), King.new(2, [0, 4]),
      Bishop.new(2, [0, 5]), Knight.new(2, [0, 6]), Rook.new(2, [0, 7])
    ]
  end

  def white_row
    [
      Rook.new(1, [7, 0]), Knight.new(1, [7, 1]), Bishop.new(1, [7, 2]),
      Queen.new(1, [7, 3]), King.new(1, [7, 4]),
      Bishop.new(1, [7, 5]), Knight.new(1, [7, 6]), Rook.new(1, [7, 7])
    ]
  end

  def white_pieces(white_pieces = [])
    @squares.each do |row|
      row.each do |square|
        unless square == ' '
          white_pieces << square if square.symbolic_color == :white
        end
      end
    end
    white_pieces
  end

  def black_pieces(black_pieces = [])
    @squares.each do |row|
      row.each do |square|
        unless square == ' '
          black_pieces << square if square.symbolic_color == :black
        end
      end
    end
    black_pieces
  end

  def find_piece(player_color, piece_type)
    @disambiguated = false
    if player_color == :white
      find_white_piece(piece_type)
    else
      find_black_piece(piece_type)
    end
  end

  def find_white_piece(piece_type)
    pieces = white_pieces_that_go_to_dest.select do |piece|
      piece.instance_of?(piece_type) &&
        valid_move?(piece.location[0], piece.location[1], :white, piece)
    end
    if pieces.length > 1
      decide_which_piece_to_move(pieces, piece_type)
    else
      assign_start_location(pieces[0]) unless pieces.empty?
      pieces[0]
    end
  end

  def decide_which_piece_to_move(pieces, piece_type)
    puts "Both #{piece_type.to_s}s can go to that location"
    puts "which #{piece_type.to_s} would you like to move, #{pieces[0].location} or #{pieces[1].location}?"
    puts "enter 0 for #{pieces[0]} or enter 1 for #{pieces[1]}."
    response = gets.chomp.to_i
    assign_start_location(pieces[response])
    @disambiguated = true
    pieces[response]
  end

  def find_black_piece(piece_type)
    black_pieces_that_go_to_dest.each do |piece|
      assign_start_location(piece)
      return piece if piece.instance_of?(piece_type) &&
        valid_move?(@start_row, @start_column, :black, piece)
    end
    nil
  end

  def white_pieces_that_go_to_dest
    white_pieces.select do |piece|
      valid_move?(piece.location[0], piece.location[1], :white, piece)
    end
  end

  def black_pieces_that_go_to_dest
    black_pieces.select do |piece|
      valid_move?(piece.location[0], piece.location[1], :black, piece)
    end
  end

  def update_board
    @squares[@dest_row][@dest_column] = @squares[@start_row][@start_column]
    @squares[@start_row][@dest_column]  = ' ' if @start_column == @dest_column
    @squares[@start_row][@start_column] = ' ' if @start_column != @dest_column
    p @piece.available_squares
    @piece.update_num_moves if @piece.is_a?(Pawn)
    @piece.update_location(@dest_row, @dest_column)
    display
  end
end
