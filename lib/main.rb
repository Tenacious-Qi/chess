# frozen_string_literal: true

require 'pry'
require 'colorize'
require_relative './modules/display'
require_relative './modules/setup_board_variables'
require_relative './modules/adjacency_list_generator'
require_relative './modules/input_validator'
require_relative './modules/move_validator'
require_relative './modules/move_disambiguator'
require_relative './modules/castle_manager'
require_relative './modules/checkmate_manager'
require_relative './modules/serializer'
require_relative './game'
require_relative './board'
require_relative './empty_square'
require_relative './player'
require_relative './rook'
require_relative './knight'
require_relative './bishop'
require_relative './king'
require_relative './queen'
require_relative './pawn'

puts
puts "Welcome to my Chess game!"
puts "What would you like to do?"
puts
choices = ['two_player   ', 'one_player   ', 'load_previous']
choices.each_with_index do |_c, i|
  puts " #{choices[i]} => enter[#{i + 1}] "
end

selection = gets.chomp
loop do
  break if selection.to_i.between?(1, 3)

  choices.each_with_index do |_c, i|
    puts " #{choices[i]} => enter[#{i + 1}] \n"
  end
  selection = gets.chomp
end

game = Game.new
if selection == '1'
  game.start_game
  game.play_game
else
  game.load_game
end
