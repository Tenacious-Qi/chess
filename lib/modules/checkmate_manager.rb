# frozen_string_literal: true

module CheckmateManager

  def check?
    white_king.in_check || black_king.in_check
  end

  def white_king
   white_pieces.select { |piece| piece.is_a?(King) }[0]
  end

  def black_king
    black_pieces.select { |piece| piece.is_a?(King) }[0]
  end
  
  def mark_king_as_in_check?(player_color)
    if player_color == :white
      binding.pry
      if attack_rules_followed?(black_king.location[0], black_king.location[1], player_color, @found_piece)
        black_king.mark_as_in_check
      end
    else
      if attack_rules_followed?(white_king.location[0], white_king.location[1], player_color, @found_piece)
        white_king.mark_as_in_check
      end
    end
  end

  def scan_for_check(player_color)
    if player_color == :white
      binding.pry
      target = black_king
      @black_king_in_check = white_pieces.any? do |piece|
        attack_rules_followed?(target.location[0], target.location[1], player_color, piece)
      end
      target.mark_as_in_check if @black_king_in_check
    else
      binding.pry
      target = white_king
      @white_king_in_check = black_pieces.any? do |piece|
         attack_rules_followed?(target.location[0], target.location[1], player_color, piece)
      end
      target.mark_as_in_check if @white_king_in_check
    end
  end

  # def move_puts_player_in_check?(piece, player_color)
  #   if player_color == :black
  #     piece.update_location(@dest_row, @dest_column)
  #     result = white_pieces.any? { |piece| attack_rules_followed?(piece.location[0], piece.location[1], :black, black_king) }
  #   end
  #   piece.update_location(@start_row, @start_column)
  #   result
  # end
end 