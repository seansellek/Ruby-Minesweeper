class Risk_Calculator
  @@bordering = [
    [-1,-1], #upper-left
    [-1,0], #top
    [-1,1], #upper-right
    [0,1], #right
    [1,1], #lower-right
    [1,0], #bottom
    [1,-1], #lower-left
    [0,-1] #left
  ]

  def initialize()

  end

  def calculate(board, index)
    r,c = get_coords(board.width, index)
    last = board.width - 1
    count = 0

    @@bordering.each_with_index do |translation,j| #test each bordering square
      origin_coords = [r,c] #set origin square
      test_coords = [] #initialize test_square
      translation.each_with_index do |shift, i| #set test_square using translation from range[i]
        test_coords[i] = origin_coords[i] + shift 
      end

      if test_coords.include?(0) || test_coords.include?(board.width + 1) #check if test square is in bounds of board
        #there is not row zero     there is no $width+1 column
        next #begin checking next bordering square
      end

      test_index = get_address(board.width,test_coords[0],test_coords[1]) #get the address of the test_square
      if board.board[test_index].value == $bomb then count+=1 end #check if test square is a bomb, if so increment count
    end
    
    if count.zero?
      return nil
    else
      return count
    end
  end

end