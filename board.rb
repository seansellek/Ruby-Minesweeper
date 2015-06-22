class Board
  attr_accessor :board, :width, :mine_count

  def initialize(args)
    @width = args[:rows]
    @mine_count = args[:mine_count]
    @board = []
  end

  def populate
    #populate Board with correct number of mines
    (@width*@width).times do |i|
      if (i<@mine_count.to_i)
        @board.push( Square.new(:bomb) )
      else
        @board.push( Square.new(:empty) )
      end
    end
  end

  def shuffle!
    @board.shuffle!
  end

  def add_adjacent_counts
    risk = Risk_Calculator.new()
    @board.length.times do |i|
      unless @board[i].value == :bomb
        bordering = risk.calculate(self,i)
        p bordering
        if bordering > 0 then @board[i].value = bordering end
      end
    end
  end

end
