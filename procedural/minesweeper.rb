########################################################
#                    Emoji Minesweeper                 #
#                     Main Functions                   #
########################################################
# 
# Instructions
#
# To play default game: ruby minesweeper.rb
# To customize size of board and number of mines: ruby minesweeper.rb size mines
# (ex: for a board 9 spaces wide and with 10 mines => ruby minesweeper.rb 9 10 )



##
# PREPARE BOARD
# => builds a board, populates it with mines, and populates mine proximity values
##
def prepare_board(size = 9, num_mines = 10)
  $board = []
  $bomb = "💣 "
  $empty = "▪︎ "
  $exploded= "💥"
  $width = size.to_i
  $num_mines = num_mines.to_i
  $bordering = [
    [-1,-1], #upper-left
    [-1,0], #top
    [-1,1], #upper-right
    [0,1], #right
    [1,1], #lower-right
    [1,0], #bottom
    [1,-1], #lower-left
    [0,-1] #left
  ]

  ($width*$width).times do |i|
    if (i<num_mines.to_i)
      $board.push({
        value: $bomb,
        revealed?: false,
      })
    else
      $board.push({
        value: $empty,
        revealed?: false
      })
    end
  end
  $board.shuffle!

  $board.length.times do |i|
    unless $board[i][:value] == $bomb
      $board[i][:value] = get_adjacent_bomb_count(i)
    end
  end
end



##
# PRINT BOARD
# => Displays board screen with (currently bad) formatting
##
def print_board(*game_over)
  if !(defined? $board); puts "Run prepare_board"; return; end

  output = " "
  $width.times do |i| #Output Header
    if (i < 9)
      output << "  #{i+1}" << ""
    elsif (i == 9)
      output << "  #{i+1}" << ""
    else
      output << " #{i+1}" << ""
    end
  end

  $board.each_with_index do |square, i| #Display each square
    line_lett = get_letter(i/$width)
    
    if (i % $width == 0)
      output << "\n#{line_lett}  "  #print row letter
    end

    if (square[:flagged?])
      if game_over[0] && square[:value] == $bomb
        output << "✅  "
      elsif game_over[0]
        output << "❌  "
      else
        output << "🚩  "
      end
    elsif (!square[:revealed?]) #check if square is revealed or not
      output << "⬛ ️ "
    else 
      if square[:value] != $empty && square[:value] != $bomb
        output << "#{square[:value]}  " #output value
      else
        output << "#{square[:value]} "
      end
    end
  end

  puts output
end



##
# GET ADJACENT BOMB COUNT
# => Returns integer representing count of adjacent bombs for a given address
##
def get_adjacent_bomb_count(address)
  r,c = get_coords(address)
  last = $width - 1
  count = 0

  $bordering.each_with_index do |translation,j| #test each bordering square
    origin_square = [r,c] #set origin square
    test_square = [] #initialize test_square
    translation.each_with_index do |shift, i| #set test_square using translation from range[i]
      test_square[i] = origin_square[i] + shift 
    end

    if test_square.include?(0) || test_square.include?($width+1) #check if test square is in bounds of board
      #there is not row zero     there is no $width+1 column
      next #begin checking next bordering square
    end

    test_address = get_address(test_square[0],test_square[1]) #get the address of the test_square
    if $board[test_address][:value] == $bomb then count+=1 end #check if test square is a bomb, if so increment count
  end
  
  ##The following is an example of horrible code I wrote. It was impossible to debug and will serve as a reminder to not write any more horrible code.
  # if !(r.zero? || c.zero?) && $board[get_address(r-1,c-1)][:value] == $bomb then count+=1 end
  # if !(r.zero?) && $board[get_address(r-1,c)][:value] == $bomb then count+=1 end
  # if !(r.zero? || c == last) && $board[get_address(r-1,c+1)][:value] == $bomb then count+=1 end 
  # if !(c == last) && $board[get_address(r,c+1)][:value] == $bomb then count+=1 end
  # if !(r == last || c == last) && $board[get_address(r+1,c+1)][:value] == $bomb then count+=1 end
  # if !(r == last) && $board[get_address(r+1,c)][:value] == $bomb then count+=1 end
  # if !(r == last || c.zero?) && $board[get_address(r+1,c-1)][:value] == $bomb then count+=1 end
  # if !(c.zero?) && $board[get_address(r,c-1)][:value] == $bomb then count+=1 end

  if count.zero?
    return $empty
  else
    return count
  end
end



##
# TAKE TURN
# => Caries out one turn given the selected square as input ("A",1)
##
def take_turn(row_lett, col)
  address = get_address(row_lett,col)

  if $board[address][:value] == $bomb #If bomb was selected, end game
    $board[address][:revealed?] = true
    $board[address][:value] = $exploded
  elsif $board[address][:value] != $empty #Elsif number selected, simply reveal tile and end turn
    $board[address][:revealed?] = true
  else #if blank square was selected
    r,c = get_coords(address) 
    traverse_from(r,c) #run traversal algoritm
  end
end



##
# TRAVERSE
# => When given the coordinates of an empty square, reveals every neighboring square up to and including the first nonempty squares
##
def traverse_from(r,c)
  square = $board[get_address(r,c)] #save current square
  if square[:value] == $empty && !square[:visited?] #if current square is empty and not visited, mark it visited and reveal it
   square[:visited?] = true 
   square[:revealed?] = true
  else #if it is a nonempty square, exit early (don't traverse neighbors)
    square[:revealed?] = true
    return
  end

  $bordering.each_with_index do |translation,j| #visit each bordering square
    origin_square = [r,c] #set origin square
    test_square = [] #initialize test_square
    translation.each_with_index do |shift, i| #set test_square using translation from $bordering[i]
      test_square[i] = origin_square[i] + shift 
    end
    unless test_square.include?(0) || test_square.include?($width+1) #Check to make sure test square is in board
      traverse_from(test_square[0],test_square[1]) #begin traversal from test_square
    end
  end
end



##
# PLAY
# => Main function. Starts a new game.
##
def play(width, bombs)
  prepare_board(width, bombs)
  game_over = false

  until game_over do #as long as the game is still going, keep playing
    #print current state of game 
    system('clear') 
    print_header 
    print_board 
    print "\n\nInput: " 
    input = STDIN.gets.chomp  #get player's choice

    #If player selected a tile
    if input =~ /^[A-#{get_letter($width-1)}][1-#{$width}]$/i then
      lett = input.split('')[0]
      col = input.split('')[1].to_i

      take_turn(lett,col) #pass player's selection to take_turn()
      game_over = game_over? #check if game is done

    #If player flagged a tile
    elsif input =~ /^flag [A-#{get_letter($width)}][1-#{$width}]$/i then
      input = input.split(' ')
      lett = input[1].split('')[0]
      col = input[1].split('')[1].to_i

      flag(lett, col) #pass player's flag selection to flag()
      game_over = game_over? #check if game is done

    #If incorrect input is entered
    else
      puts "'#{input}' is incorrect input"
      sleep(1)
    end
  end

  end_game #Once we exit the loop, finish the game
end

##
# END GAME
# => Ends the game
##
def end_game
  #ask the player if they want to keep playing
  keep_asking = true
  while keep_asking do 
    #print revealed board
    reveal_all
    system('clear')
    print_header
    print_board(true)
    print "\n\n"

    score, good_flags, bad_flags = get_score #get the score (how many bombs were successfully flagged)
    print score == $num_mines ? "YOU WIN! " : "\aGAME OVER! " #check if player won or not
    print "Your Score: #{score}"#display score
    if good_flags > 0 || bad_flags > 0 then print " (" end
    if good_flags > 0 then print "#{good_flags} correctly flagged mine#{good_flags>1 ? 's' : ''}" end
    if good_flags > 0 && bad_flags > 0 then print " - " end
    if bad_flags > 0 then print "#{bad_flags} false positive#{bad_flags > 1 ? 's' : ''}" end 
    if good_flags > 0 || bad_flags > 0 then puts ")" end
    #ask if player wants to keep playing 
    print "\nPlay Again? (y/n) " 
    play_again = STDIN.gets.chomp

    #verify input, and perform action player selects
    if /^ye?s?$/i =~ play_again 
      play($width,$num_mines)
    elsif /^no?$/i =~ play_again
      keep_asking = false
    else
      puts "'#{play_again}' is invalid inupt"
      sleep(1)
    end
  end
end
########################################################
#                    Emoji Minesweeper                 #
#                    Utility Functions                 #
########################################################

##
#  REVEAL
# => Toggles given square as revealed. Takes "A",1 format arguments
##
def reveal(row_lett, column)
  if !(defined? $board); puts "Run prepare_board"; return; end

    address = get_address(row_lett, column)
    $board[address][:revealed?] = true
end



##
#  REVEAL ALL
# => Toggles given square as revealed. Takes "A",1 format arguments
##
def reveal_all
    $board.length.times do |i|
      $board[i][:revealed?] = true
    end
end


##
#  GAME OVER?
# => Checks if game is over in a win or draw situation
##
def game_over?
  $board.each do |square|
    if square[:value] == $exploded
     return true
   end
  end

  $board.each do |square|
    if !square[:revealed?] && !square[:flagged?] 
     return false
   end
  end

  return true
end



##
#  GET INDEX (LETTER)
# => returns the index of alphabet for any given letter (A,a = 0)
##
def get_index(letter)
  ascii = letter.ord
  if (ascii < 97)
    return letter.ord - 65
  else
    return letter.ord - 97
  end
end



##
#  GET LETTER (INDEX)
# => Returns the letter for a given index (0=A)
##
def get_letter(index)
  return (index+65).chr
end



##
#  GET ADDRESS
# => given a row and column number, returns address ("A",1 => 0), (1,1 => 0)
##
def get_address(row, col)
  if (row.class == String)
    address = (get_index(row)) * $width + (col - 1)
  else
    address = (row-1) * $width + (col-1)
  end
  return address
end



##
# FLAG
# => flags selected square
##
def flag(row_lett, col)
  address = get_address(row_lett, col)
  $board[address][:flagged?] = !$board[address][:flagged?]
end



##
#  GET COORDS (ADDRESS)
# => given a 0-index address, returns row and column numbers (0 = > [1,1])
##
def get_coords(address)
  r = (address/$width) +1
  c = (address % $width) +1
  return [r,c]
end


##
#  PRINT HEADER
# => prints out the headerf
##
def print_header()
  puts '    __  ____                                              
   /  |/  (_____  ___  ______      _____  ___  ____  _____
  / /|_/ / / __ \/ _ \/ ___| | /| / / _ \/ _ \/ __ \/ ___/
 / /  / / / / / /  __(__  )| |/ |/ /  __/  __/ /_/ / /    
/_/  /_/_/_/ /_/\___/____/ |__/|__/\___/\___/ .___/_/     
                Developed by @SeanSellek  /_/'
  puts "\n "
  puts "Welcome to Minesweepr! Instructions:\n\n To select A1 => a1 \n To flag tile => flag a1\n\n"
end

##
#  GET SCORE
# => returns array of integer score, mines correctly flagged, and mines incorrectly flagged
##
def get_score()
  score = 0
  good_flags = 0
  bad_flags = 0
  $board.each do |square|
    if square[:value] == $bomb && square[:flagged?]
      score += 1
      good_flags += 1
    elsif square[:value] != $bomb && square[:flagged?]
      score -= 1
      bad_flags +=1
    end
  end
  return [score, good_flags, bad_flags]
end

def ask_to_play_again()

end

########################################################
#                    Emoji Minesweeper                 #
#                        The Game                      #
########################################################

rows = (ARGV[0]|| 9)
bombs = (ARGV[1] || 10)

play(rows, bombs)

