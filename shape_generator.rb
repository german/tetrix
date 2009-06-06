SHAPES = [ 
  [[10,10], [10,11], [10,12]], 
  
  [[10,10],[11,10],[11,11],[11,12],[12,12]],
   
  [[10,10],[10,11],[11,10],[11,11]],
  
  [[10,10],[11,10],[12,10],[13,10],[14,10]]
]

class ShapeGenerator
  def self.get_shape
    color = SHAPE_COLORS[rand(SHAPE_COLORS.size)]
    shape = SHAPES[rand(SHAPES.size)]
    arr = []
    shape.each do |cell|      
      arr << Cell.new(cell[0], cell[1], color, MOVING)
    end
    arr
  end
end
