require "./board.rb"
require "./square.rb"
require "./io.rb"
require "./game.rb"

board = Board.new(9,10)
io = IO.new()
game = Game.new(board,io)


game.play


