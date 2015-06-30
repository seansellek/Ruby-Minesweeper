class UI
  def initialize(board)
    @board = board
    # @game = game
  end

  def clear
    system('clear')
  end

  def draw_game(_board, game_over = false)
    clear
    print_header
    draw_board(@board, game_over)
    puts "\n"
  end

  def draw_board(board, game_over = false)
    output = ' '
    width = board.width

    width.times do |i| # Output Header
      if i < 9
        output << "  #{i + 1}" << ''
      elsif (i == 9)
        output << "  #{i + 1}" << ''
      else
        output << " #{i + 1}" << ''
      end
    end

    # num_rows = i/width
    # letter = "A"
    # num_rows.times { letter = letter.next }

    board.each_with_index do |square, i|
      output << "\n#{('A'.ord + (i / width)).chr}  " if (i % width == 0)

      if square.flagged?
        if game_over
          if square.value == :bomb
            output << '✅  '
          else
            output << '❌  '
          end
        else
          output << '🚩  '
        end
      elsif square.exploded?
        output << '💥  '
      elsif square.revealed?
        # output << case square.value
        #           when :bomb
        #           when :empty
        #           else
        #             "#{square.value} "
        #           end
        output << '💣  ' if square.value == :bomb
        output << '▪︎  ' if square.value == :empty
        output << "#{square.value}  " if square.value.is_a? Fixnum
      else
        output << '⬛ ️ '
      end
    end
    puts output
  end

  # def display_square(square)

  # end

  def get_input(prompt = 'Input: ')
    print prompt
    input = STDIN.gets.chomp
    input
  end

  def incorrect(input)
    puts "'#{input}' is incorrect input"
    sleep(1)
  end

  def print_header
    puts '    __  ____
   /  |/  (_____  ___  ______      _____  ___  ____  _____
  / /|_/ / / __ \/ _ \/ ___| | /| / / _ \/ _ \/ __ \/ ___/
 / /  / / / / / /  __(__  )| |/ |/ /  __/  __/ /_/ / /
/_/  /_/_/_/ /_/\___/____/ |__/|__/\___/\___/ .___/_/
                Developed by @SeanSellek  /_/'
    puts "\n "
    puts "Welcome to Minesweepr! Instructions:\n\n To select A1 => a1 \n To flag tile => flag a1\n\n"
  end

  def show_score(score)
    good_flags = score[:good_flags]
    bad_flags = score[:bad_flags]
    won = score[:won?]
    score = score[:score]
    print won ? 'YOU WIN! ' : "\aGAME OVER! "
    print "Your Score: #{score}"
    print ' (' if good_flags > 0 || bad_flags > 0
    if good_flags > 0 then print "#{good_flags} correctly flagged mine#{good_flags > 1 ? 's' : ''}" end
    print ' - ' if good_flags > 0 && bad_flags > 0
    if bad_flags > 0 then print "#{bad_flags} false positive#{bad_flags > 1 ? 's' : ''}" end
    puts ')' if good_flags > 0 || bad_flags > 0
    puts '' if good_flags == 0 && bad_flags == 0
  end
end
