require 'gnomecanvas2'
require 'cell'
require 'shape'
require 'shape_generator'
require 'container'

MOVING = 1
EMPTY = 0
NOT_MOVING = 2

RATING_STEP = 10

DEFAULT_COLOR = '#FFFFFF'
NOT_MOVING_COLOR = '#E4E4E4'
SHAPE_COLORS = ['#D40000', '#00FF00']

TICK_INTERVAL = 500

ROWS = 25
COLUMNS = 21
CELL_BORDER = 1
CELL_HEIGHT = CELL_WIDTH = 10
WINDOW_WIDTH = COLUMNS * (CELL_WIDTH + (CELL_BORDER*2))
WINDOW_HEIGHT = ROWS * (CELL_HEIGHT + (CELL_BORDER*2))

class MainWindow < Gtk::Window
  def initialize
    super

    @container = Container.new
    @shape = Shape.new @container

    @vbox = Gtk::VBox.new(false, 0)
    add @vbox

    @current_x = 10
    @current_y = 10

    create_canvas_and_add_to_window

    ag = Gtk::AccelGroup.new

    ag.connect(Gdk::Keyval::GDK_Right, Gdk::Window::LOCK_MASK, Gtk::ACCEL_VISIBLE) { 
      @shape.move :direction => 'right' if @shape.can_move :to => 'right'
    }
    ag.connect(Gdk::Keyval::GDK_Left, Gdk::Window::LOCK_MASK, Gtk::ACCEL_VISIBLE) { 
      @shape.move :direction => 'left' if @shape.can_move :to => 'left'
    }
    ag.connect(Gdk::Keyval::GDK_Up, Gdk::Window::LOCK_MASK, Gtk::ACCEL_VISIBLE) { @shape.rotate }

    add_accel_group(ag)

    @tid= Gtk::timeout_add(TICK_INTERVAL) { tick(); true }

    signal_connect('destroy') {
      Gtk.main_quit
    }  
  end

  def tick
    if @shape.can_move :to => 'bottom'
      @shape.move :direction => 'down'
      @container.check_full_rows!              
    else      
      @shape = Shape.new(@container) if @container.shape_can_be_issued?
    end
    
    create_canvas_and_add_to_window
  end

  def create_canvas_and_add_to_window
    if @canvas
      @vbox.remove(@canvas)
      @canvas.destroy
    end

    @canvas = Gnome::Canvas.new
    @canvas.set_size_request(WINDOW_WIDTH, WINDOW_HEIGHT)
    @canvas.set_scroll_region(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT)

    @container.show_cells @canvas

    @vbox.pack_end(@canvas, true, true, 0)
    @vbox.show_all
  end 
end

if __FILE__ == $0
  MainWindow.new.show_all
  Gtk.init  
  Gtk.main
end
