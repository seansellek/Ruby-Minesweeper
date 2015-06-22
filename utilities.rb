module Utilities

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
  def get_address(width, row, col)
    if (row.class == String)
      address = (get_index(row)) * width + (col - 1)
    else
      address = (row-1) * width + (col-1)
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
  def get_coords(width, address)
    r = (address/width) +1
    c = (address % width) +1
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
end
