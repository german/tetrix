class Shape  
  def initialize(belongs_to_container)
    @shape = ShapeGenerator.get_shape
    @container = belongs_to_container
    @container.shape = self
  end
  
  def move options
    empty_current_place!
    @shape.each do |cell|
      cell.move :to => options[:direction] #if can_move :to => options[:direction]
    end
    @shape.each{|cell| cell.not_moving! } if not can_move :to => 'bottom'
    reflect_to_container!
  end
  
  def rotate
    window_to_rotate = get_dimensions
        
    return if there_is_no_space_to_rotate_in window_to_rotate
    
    empty_current_place!
    
    # actually transpond
    @shape.each do |cell| 
      # calculate relative offset (in rotating window) otherwise we will be transponding in all container
      offset_row, offset_column = cell.row - window_to_rotate[:min_row], cell.column - window_to_rotate[:min_column]
      
      # transpond that offset
      offset_row, offset_column = offset_column, offset_row
      cell.row, cell.column = window_to_rotate[:min_row] + offset_row, window_to_rotate[:min_column] + offset_column
    end
    
    reflect_to_container!
  end
  
  def can_move options
    case options[:to]
      when 'left'
        @shape.each do |cell| 
          cell_at_left = @container.at(cell.row, cell.column - 1)
          return false if cell_at_left.nil? || cell_at_left.not_moving?
        end
        return true
      when 'right'
        @shape.each do |cell| 
          cell_at_right = @container.at(cell.row, cell.column + 1)
          return false if cell_at_right.nil? || cell_at_right.not_moving?
        end
        return true
      when 'bottom'
        @shape.each do |cell| 
          cell_at_bottom = @container.at(cell.row + 1,cell.column)
          return false if cell_at_bottom.nil? || cell_at_bottom.not_moving?
        end
        return true
    end
  end
  
  def empty_current_place!
    @shape.each do |cell|
      @container.replace Cell.new(cell.row, cell.column, DEFAULT_COLOR )
    end
  end
  
  def reflect_to_container!
    @shape.each do |cell|
      @container.replace cell
    end
  end
    
  def get_dimensions 
    min_row = @shape[0].row
    max_row = @shape[0].row
    min_column = @shape[0].column
    max_column = @shape[0].column

    @shape.each do |cell|
      min_row = cell.row if cell.row < min_row
      max_row = cell.row if cell.row > max_row
      min_column = cell.column if cell.column < min_column
      max_column = cell.column if cell.column > max_column
    end
    
    abs_row = max_row - min_row
    abs_column = max_column - min_column
            
    if abs_row > abs_column
      window_to_rotate = {:min_column => min_column - abs_row/2, :min_row => min_row, :max_column => max_column + abs_row/2, :max_row => max_row}
    elsif abs_column > abs_row
      window_to_rotate = {:min_column => min_column, :min_row  => min_row - abs_column/2, :max_column => max_column, :max_row => max_row + abs_column/2}
    else
      window_to_rotate = {:min_column => min_column, :min_row  => min_row, :max_column => max_column, :max_row => max_row}
    end

    window_to_rotate[:width] = (max_column - min_column) + 1
    window_to_rotate[:height]= (max_row    - min_row) + 1
    
    window_to_rotate
  end
  
  private
    def there_is_no_space_to_rotate_in window
      window[:min_row].upto(window[:max_row]) do |row|
        window[:min_column].upto(window[:max_column]) do |column| 
          return true if @container.at(row, column).not_moving?
        end
      end
      return false
    end
end
