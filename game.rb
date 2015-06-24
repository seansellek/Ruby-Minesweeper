class Game
  attr_accessor :playing, :board, :traverser, :io
  def initialize(board, io)
    @board = board
    @io = io
    @traverser = Traverser.new(board)
    @playing = true
  end

  def select(row_letter, column)
    coordinates = [get_row_number(row_letter), column]
    index = board.get_index(coordinates)
    if board[index].value == :bomb
      board[index].reveal
      board[index].explode
    elsif board[index].value != :empty
      board[index].reveal
    else
      traverser.go(coordinates)
    end
    @playing = !game_over?
  end

  def flag(row_letter, column)
    coordinates = [get_row_number(row_letter), column]
    index = board.get_index(coordinates)
    board[index].flag
    @playing = !game_over?
  end

  def over?
    !playing
  end

  def take_turn
    user_action = false
    until user_action do
      io.clear
      io.draw_game(board)
      input = io.get_input
      user_action = validate_turn input
      io.incorrect(input) unless user_action
    end
    select(user_action[1],user_action[2]) if user_action[0] == :select
    flag(user_action[1],user_action[2]) if user_action[0] == :flag
  end

  def validate_turn(input)
    if input =~ /^[A-#{(board.width-1+65).chr}][1-#{board.width}]$/i then
      lett = input.split('')[0]
      col = input.split('')[1].to_i

      return [:select, lett, col]

    #If player flagged a tile
    elsif input =~ /^flag [A-#{(board.width-1+65).chr}][1-#{board.width}]$/i then
      input = input.split(' ')
      lett = input[1].split('')[0]
      col = input[1].split('')[1].to_i

      return [:flag, lett, col]
     #If incorrect input is entered
    else
      return false
    end
  end

  def validate_yes_no(input)
    if /^ye?s?$/i =~ input 
      return :yes
    elsif /^no?$/i =~ input
      return :no
    else
      return input
    end
  end

  def play
    while playing do 
      take_turn
    end
    end_game
  end

  def end_game
    keep_asking = true
    while keep_asking do
      board.reveal_all
      io.clear
      io.draw_game(board)
      io.show_score score
      input = io.get_input("Play Again? (y/n) ")
      input = validate_yes_no(input)
      if input == :yes
        reset
        play
      elsif input == :no
        keep_asking = false
      else
        io.incorrect(input)
      end
    end   
  end

  def reset
    board = Board.new(9,10)
    playing = true
    p playing
    traverser = Traverser.new(board)
  end

  def score
    score = 0
    good_flags = 0
    bad_flags = 0
    board.each do |square|
      if square.value == :bomb && square.flagged?
        score += 1
        good_flags += 1
      elsif square.value != :bomb && square.flagged?
        score -= 1
        bad_flags += 1
      end
    end
    won = board.num_mines == good_flags

    return {score: score, good_flags: good_flags, bad_flags: bad_flags, won?: won}
  end


  Traverser = Struct.new(:board) do
    def initialize(board)
      @board = board
      @visited = Array.new(board.length) { false }
      @bordering = [
        [-1,-1], #upper-left
        [-1,0], #top
        [-1,1], #upper-right
        [0,1], #right
        [1,1], #lower-right
        [1,0], #bottom
        [1,-1], #lower-left
        [0,-1] #left
      ]
    end

    def go(coordinates)
      index = @board.get_index(coordinates)
      square = @board[index]
      if square.is_empty?  and !@visited[index]
        @visited[index] = true
        square.reveal
      else 
        square.reveal
        return
      end

      @bordering.each do |translation|
        test_square = coordinates.zip(translation).map {|e| e.inject(:+) }
        unless test_square.include?(0) || test_square.include?(@board.width + 1)
          go(test_square)
        end
      end 
    end

  end

  private

  def get_row_number(row_letter)
    row_letter.ord > "Z".ord ? row_letter.ord - "a".ord + 1 : row_letter.ord- "A".ord + 1  
  end

  def game_over?
    board.each { |square| return true if square.exploded? }
    board.each { |square| return false if !square.revealed? && !square.flagged?}
    return true
  end


end

