require "./board.rb"
require "./square.rb"
require "./ui.rb"
require "./game.rb"

board = Board.new(9,10)
ui = UI.new(board)
game = Game.new(board,ui)



game.play
