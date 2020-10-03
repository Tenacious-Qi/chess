# frozen_string_literal: true

class Board
  include Display
  include MoveValidator
  include SetupBoardVariables
  attr_reader :start_row, :start_column, :piece, :piece_type
  
  def initialize(squares = make_initial_board)
    @squares = squares
    @start_column = nil
    @dest_column = nil
    @start_row = nil
    @dest_row = nil
    @piece = nil
    @piece_type = nil
    @piece_prefix = nil
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
    if player_color == :white
      find_white_piece(piece_type)
    else
      find_black_piece(piece_type)
    end
  end

  def find_white_piece(piece_type)
    pieces = white_pieces_that_go_to_dest.select do |piece|
      # assign_start_location(piece)
      piece.instance_of?(piece_type) &&
        valid_move?(piece.location[0], piece.location[1], :white, piece)
    end
    puts "start_row: #{@start_row}"
    puts "start_column: #{@start_column}"
    p pieces
    if pieces.length > 1
      assign_start_location(pieces[1])
      pieces[1]
    else
      # ask player which piece they want to move, a or b. 
      # going to need the location, maybe use the column?
      # puts 'two pieces can move to that location'
      # puts' 
      # selection = gets.chomp
      # if selection matches column, move the piece in that column.
      assign_start_location(pieces[0])
      pieces[0]
    end
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
