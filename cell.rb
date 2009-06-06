class Cell
  attr_accessor :mode, :row, :column, :color
  
  def initialize(row, column, color, mode = EMPTY)
    @row = row
    @column = column
    @color = color    
    @mode = mode; # MOVING | EMPTY | NOT_MOVING    
  end
  
  def empty?
    @mode == EMPTY
  end
  
  def not_moving!
    @mode = NOT_MOVING
  end

  def moving?
    @mode == MOVING
  end
    
  def not_moving?
    @mode == NOT_MOVING
  end
    
  def move options
    case options[:to]
      when 'down'
  	    @row += 1
  	  when 'right'
        @column += 1
      when 'left'
        @column -= 1
    end
  end
end
