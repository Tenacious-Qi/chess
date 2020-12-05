# frozen_string_literal: true

module Display
  
  WHITE = "\u265F".colorize(:light_yellow).freeze
  BLACK = "\u265F".colorize(:cyan).freeze

  def display(starting_row = 8)
    puts `clear` if !@self_in_check
    print_captured_white_pieces
    @squares.each_with_index do |row, index|
      print "  #{starting_row} "
      index.even? ? print_even_row(row) : print_odd_row(row)
      starting_row -= 1
      puts "\n"
    end
    print "     a   b   c   d   e   f   g   h\n\n"
    print_captured_black_pieces
  end

  def print_captured_white_pieces
    if @captured_by_black.any?
      @captured_by_black.each { |piece| print "  #{piece.displayed_color}"}
    end
    puts "\n\n"
  end

  def print_captured_black_pieces
    if @captured_by_white.any?
      @captured_by_white.each { |piece| print "  #{piece.displayed_color}"}
    end
    puts
  end

  def print_even_row(row)
    row.each_with_index do |square, col_index|
      col_index.even? ? print_on_light_black(square) : print_on_black(square)
    end
  end

  def print_odd_row(row)
    row.each_with_index do |square, col_index|
      col_index.even? ? print_on_black(square) : print_on_light_black(square)
    end
  end

  def print_on_light_black(square)
    print "    ".on_light_black if square.is_a?(EmptySquare)
    unless square.is_a?(EmptySquare)
      if square == @active_piece 
        print " #{square.displayed_color}  ".on_magenta
      else
        print " #{square.displayed_color}  ".on_light_black
      end
    end
  end

  def print_on_black(square)
    print "    ".on_black if square.is_a?(EmptySquare)
    unless square.is_a?(EmptySquare)
      if square == @active_piece 
        print " #{square.displayed_color}  ".on_magenta
      else
        print " #{square.displayed_color}  ".on_black
      end
    end
  end

  def announce_checkmate_or_stalemate(player, _checkmate, _stalemate)
    puts "  ** Checkmate! #{player.symbolic_color.capitalize} wins! ** ".colorize(:green) if @checkmate
    puts '  ** Stalemate. Game ends in a draw **'.colorize(:green) if @stalemate
  end

  def thanks_for_playing
    " Thanks for playing! Have a great day!".colorize(:green)
  end

  def show_help
    puts <<-HEREDOC
    
    available commands: save|load|help|quit|resign|draw
    Move examples:
      Pawns: e5, exd6, a5, axb6, etc . . .
      Main Pieces: Ke7, Kxe7, Nc3, Nxc6, etc . . .
      Castles: 0-0, 0-0-0

    This game uses traditional algebraic notation to enter moves.
    Attack moves must preface destination square with 'x'
    

    Each piece, except the Pawn, is assigned a piece prefix:
    King, Queen, Rook, Knight, Bishop = K, Q, R, N, B

    Moves are case sensitive.
    If more than one piece can go to a location, you'll be prompted to select one.

    HEREDOC
  end
end
