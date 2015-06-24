class IO
  def initialize

  end

  def clear
    system('clear')
  end
  def draw_game(board, game_over=false)
    clear
    print_header
    draw_board(board, game_over)
    STDOUT.puts "\n"
  end

  def draw_board(board, game_over = false)
    output = " "
    width = board.width

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
        if game_over && square.value == :bomb
          output << "✅  "
        elsif game_over
          output << "❌  "
          else 
          output << "🚩  "
        end
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
    STDOUT.puts output
  end

  def get_input(prompt = "Input: ")
    STDOUT.print prompt
    input = STDIN.gets.chomp
    return input
  end

  def incorrect(input)
    STDOUT.puts "'#{input}' is incorrect input"
    sleep(1)
  end

  def print_header
    STDOUT.puts '    __  ____                                              
   /  |/  (_____  ___  ______      _____  ___  ____  _____
  / /|_/ / / __ \/ _ \/ ___| | /| / / _ \/ _ \/ __ \/ ___/
 / /  / / / / / /  __(__  )| |/ |/ /  __/  __/ /_/ / /    
/_/  /_/_/_/ /_/\___/____/ |__/|__/\___/\___/ .___/_/     
                Developed by @SeanSellek  /_/'
    STDOUT.puts "\n "
    STDOUT.puts "Welcome to Minesweepr! Instructions:\n\n To select A1 => a1 \n To flag tile => flag a1\n\n"
  end

  def show_score score
    good_flags = score[:good_flags]
    bad_flags = score[:bad_flags]
    won = score[:won?]
    score = score[:score]
    STDOUT.print won ? "YOU WIN! " : "\aGAME OVER! "
    STDOUT.print "Your Score: #{score}"
    if good_flags > 0 || bad_flags > 0 then STDOUT.print " (" end
    if good_flags > 0 then STDOUT.print "#{good_flags} correctly flagged mine#{good_flags>1 ? 's' : ''}" end
    if good_flags > 0 && bad_flags > 0 then STDOUT.print " - " end
    if bad_flags > 0 then STDOUT.print "#{bad_flags} false positive#{bad_flags > 1 ? 's' : ''}" end 
    if good_flags > 0 || bad_flags > 0 then STDOUT.puts ")" end
    if good_flags == 0 && bad_flags ==  0 then STDOUT.puts "" end
  end

end