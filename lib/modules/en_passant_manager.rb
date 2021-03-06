# frozen_string_literal: true

# validates en_passant moves and handles board update when there is an en passant move
module EnPassantManager
  def en_passant_move?(squares, start_row, _start_column, dest_row, dest_column)
    return false unless squares[dest_row][dest_column].is_a?(EmptySquare)

    if @symbolic_color == :white && (dest_row + 1).between?(0, 7)
      target = squares[dest_row + 1][dest_column]
      valid_white_en_passant?(start_row, target)
    elsif @symbolic_color == :black && (dest_row - 1).between?(0, 7)
      target = squares[dest_row - 1][dest_column]
      valid_black_en_passant?(start_row, target)
    end
  end

  def valid_white_en_passant?(start_row, target)
    start_row == 3 &&
      target.symbolic_color != @symbolic_color &&
      target.is_a?(Pawn) &&
      target.location[0] == 3
  end

  def valid_black_en_passant?(start_row, target)
    start_row == 4 &&
      target.symbolic_color != @symbolic_color &&
      target.is_a?(Pawn) &&
      target.location[0] == 4
  end

  def manage_en_passant_attack(piece, player_color, target)
    assign_en_passant_target(player_color, target)
    # force attacking pawn to be @found_piece
    @found_piece = @squares[piece.location[0]][piece.location[1]]
    en_passant_conditions_met?(player_color)
  end

  def assign_en_passant_target(player_color, target)
    return unless target.is_a?(EmptySquare)

    @target = if player_color == :white
                @squares[target.location[0] + 1][target.location[1]]
              else
                @squares[target.location[0] - 1][target.location[1]]
              end
  end

  def en_passant_conditions_met?(player_color)
    @found_piece.is_a?(Pawn) && @target.is_a?(Pawn) &&
      @target.just_moved_two && @target == @active_piece &&
      target_is_actually_en_passant_target?(player_color)
  end

  def update_board_if_en_passant_move(player_color)
    return unless en_passant_conditions_met?(player_color)

    if player_color == :white
      @squares[@dest_row + 1][@dest_column] = EmptySquare.new([@dest_row + 1, @dest_column])
    else
      @squares[@dest_row - 1][@dest_column] = EmptySquare.new([@dest_row - 1, @dest_column])
    end
  end

  def target_is_actually_en_passant_target?(player_color)
    if player_color == :white
      @squares[@dest_row + 1][@dest_column] == @target
    else
      @squares[@dest_row - 1][@dest_column] == @target
    end
  end
end
