# Handles each square object
class Square
  attr_accessor :value, :neighbors

  def initialize(value)
    @value = value
    @flagged = false
    @revealed = false
    @exploded = false
    @neighbors = []
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

  def empty?
    @value == :empty
  end

  def bomb?
    @value == :bomb
  end
end
