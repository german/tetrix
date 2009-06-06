class Container
  attr_accessor :shape
  
  def initialize
    @container = []
    @rows = ROWS
    @columns = COLUMNS
    @rating = 0

    @rows.times do |row|
      cells_container = []
      @columns.times do |column|                
        cells_container << Cell.new(row, column, DEFAULT_COLOR)
      end
      @container << cells_container
    end    
  end
  
  def at row, column
    @container[row][column] rescue nil
  end
  
  def replace cell
    @container[cell.row][cell.column] = cell    
  end
  
  def show_cells canvas
    @rows.times do |row|
      @columns.times do |column|
        cell = @container[row][column]
        Gnome::CanvasRect.new(canvas.root, :x1 => (cell.column * CELL_WIDTH), :y1 => cell.row * CELL_HEIGHT,
                                       :x2 => (cell.column*CELL_WIDTH + CELL_WIDTH), :y2 => (cell.row*CELL_HEIGHT + CELL_HEIGHT),
                                       :fill_color => cell.color, :outline_color => "gray", :width_pixels => CELL_BORDER)

                        
      end
    end    
  end 
    
  def check_full_rows!
    (@rows-1).downto(0) do |row|
      row_is_full = true
      @columns.times do |column|
        row_is_full = false if @container[row][column].empty?
      end
      (erase_row row and next) if row_is_full
    end
  end
  
  def shape_can_be_issued?
    @shape.get_dimensions[:height].times do |row|
      @columns.times do |column|
        cell = @container[row][column]
        return false if cell.mode != EMPTY
      end
    end
    return true
  end
  
  private
  
    def erase_row row_to_erase
      @columns.times do |column|
        (row_to_erase - 1).downto(0) do |row|        
          @container[row + 1][column].mode = @container[row][column].mode
        end        
        @rating += RATING_STEP
      end
    end    
end
