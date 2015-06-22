require "./board.rb"
require "./square.rb"
require "./risk_calculator.rb"
require "./utilities.rb"

include Utilities

board = Board.new({ rows: 2, mine_count: 1})
board.populate
board.shuffle!
board.add_adjacent_counts

p board 