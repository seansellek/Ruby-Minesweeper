class Square
  attr_accessor :value

  def initialize(value)
    @value = value
    @flagged = false
    @revealed = false
    @exploded = false 
  end

  def flag
    @flagged = !@flagged
  end
  def flagged?
    @flagged
  end

  def reveal
    @revealed = true
  end
  def hide
    @revealed = false
  end
  def revealed?
    @revealed
  end
  def explode
    @exploded = !@exploded
  end
  def exploded?
    @exploded
  end
  def is_empty?
    return  @value == :empty ? true : false
  end
  def is_bomb?
    return @value == :bomb
  end
end