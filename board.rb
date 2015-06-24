class Board
  attr_accessor :width, :num_mines, :board 
  def initialize(width, num_mines)
    @width = width
    @num_mines = num_mines
    @board = Array.new(@width*@width) {Square.new(:empty)}
    add_mines 
    add_risks
    

  end

  def length 
    @board.length
  end

  def [](index)
    @board[index]
  end

  def []=(index, value)
    @board[index] = value
  end

  def each &block
    @board.each {|e| yield(e)}
  end

  def to_s
    output = " "
    width.times do |i| #Output Header
      if (i < 9)
        output << "  #{i+1}" << ""
      elsif (i == 9)
        output << "  #{i+1}" << ""
      else
        output << " #{i+1}" << ""
      end
    end

    board.each_with_index do |square, i|
      output << "\n#{("A".ord + (i/width)).chr}  " if (i % width == 0)

      if square.flagged? 
        output << "🚩  "
      elsif square.exploded?
        output << "💥  "
      elsif square.revealed?
        output << "💣  " if square.value == :bomb
        output << "▪︎  " if square.value == :empty
        output << "#{square.value}  " if square.value.class == Fixnum
      else
        output << "⬛ ️ "
      end

    end
    return output
  end

  def get_coords(index)
    row = (index / @width) + 1
    column = (index % @width) + 1
    return [row, column]
  end

  def get_index(coords)
    row = coords[0]
    column = coords[1]
    address = (row-1) * width + (column -1)
  end

  def reveal_all
    board.each {|square| square.reveal}
  end

  private

  def add_mines
    num_mines.times do |i|
      @board[i].value = :bomb
    end
    #@board.shuffle!
  end

  def add_risks
    @board.length.times do |i|
      unless @board[i].value == :bomb
        @board[i].value = get_risk(i)
      end
    end
  end

  def get_risk(index)
    origin_square = get_coords(index)
    last = @width + 1
    count = 0 
    bordering = [
      [-1,-1], #upper-left
      [-1,0], #top
      [-1,1], #upper-right
      [0,1], #right
      [1,1], #lower-right
      [1,0], #bottom
      [1,-1], #lower-left
      [0,-1] #left
    ]

    bordering.each_with_index do |translation, i|
      bordering[i] = origin_square.zip(translation).map { |e| e.inject(:+) }
    end

    bordering.each do |test_coordinates|
      next if test_coordinates.include?(0) || test_coordinates.include?(last)

      test_index = get_index(test_coordinates)

      count += 1 if board[test_index].value == :bomb
    end
    return count == 0 ? :empty : count
  end

end