# frozen_string_literal: true

module MoveValidator
  def valid_move?(start_row, start_column, player_color, piece)
    available_location?(start_row, start_column, piece) &&
      piece.allowed_move?(@dest_row, @dest_column)
  end

  def available_location?(start_row, start_column, piece)
    return allowed_knight_move?(piece) if piece.is_a?(Knight)
    return piece_in_diagonal_path?(start_row, start_column) if piece.is_a?(Bishop) && piece.location[0] == 7
    @squares[@dest_row][@dest_column] == ' ' &&
      column_has_space_for_move?(start_row, start_column) &&
      row_has_space_for_move?(start_row, start_column)
  end

  def diagonal_move?(start_row, start_column)
    start_row != @dest_row && start_column != @dest_column
  end

  # do variations of start_row - n and dest_column + n depending on move direction
  def piece_in_diagonal_path?(start_row, start_column)
    diagonal = []
    (@dest_column - start_column) + 1.times do |n|
      diagonal << @squares[start_row - n][@dest_column + n]
    end
    diagonal.any? { |s| s != ' ' } && @squares[@dest_row][@dest_column] == ' '
  end

  def allowed_knight_move?(piece)
    @squares[@dest_row][@dest_column] == ' ' &&
      piece.allowed_move?(@dest_row, @dest_column)
  end

  def column_has_space_for_move?(start_row, start_column)
    if start_row < @dest_row
      check_space_between_rows(start_row + 1, @dest_row)
    else
      check_space_between_rows(@dest_row, start_row - 1)
    end
  end

  def check_space_between_rows(starting_place, destination)
    starting_place.upto(destination) do |r|
      return false if @squares[r][@dest_column] != ' '
    end
  end

  def row_has_space_for_move?(start_row, start_column)
    if start_column < @dest_column
      check_space_between_columns(start_row, start_column + 1, @dest_column)
    else
      check_space_between_columns(start_row, @dest_column, start_column - 1)
    end
  end

  def check_space_between_columns(start_row, starting_place, destination)
    starting_place.upto(destination) do |c|  
      return false if @squares[start_row][c] != ' '
    end
  end
end
