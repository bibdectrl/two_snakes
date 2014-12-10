require 'gosu'

module SnakeGame

  Segment = Struct.new(:x, :y)
  WIDTH = 640
  HEIGHT = 480
  CELL_SIZE = 10

  def new_game players
    case players
    when 1
      return { }
    when 2
      return { }
    end
  end  

  class Snake
    attr_accessor :segments, :direction, :window, :length, :x, :y
    def initialize(window, x, y)
      @segments = [Segment.new(x, y)]
      @x = x
      @y = y
      @window = window
      @img = Gosu::Image.new(window, "segment.png")
      @direction = [:UP, :DOWN, :LEFT, :RIGHT].shuffle.first
      @length = 1
    end

    def draw
      @segments.each {|seg| @img.draw(seg.x * CELL_SIZE, seg.y * CELL_SIZE, 1) }
    end

    def touching_food? food
      segments[0].x == food.x && segments[0].y == food.y
    end

    def touching_self?
      head = @segments[0]
      @segments[1...@length].each {|seg| if seg.x == head.x && seg.y == head.y then return true end}
      false
    end

    def touching_other? other
      head = @segments[0]
      other.segments[1...other.length].each {|seg| if seg.x == head.x && seg.y == head.y then return true end}
      false
    end

    def move
      case @direction
      when :RIGHT
	@x += 1      
      when :LEFT
	@x -= 1
      when :UP
        @y -= 1
      when :DOWN
	@y += 1      
      end
      @segments = [Segment.new(x, y)] + @segments
    end

    def turn dir
      if dir == :UP && (@direction == :RIGHT || @direction == :LEFT) then @direction = :UP
      elsif dir == :DOWN  && (@direction == :RIGHT || @direction == :LEFT) then @direction = :DOWN
      elsif dir == :LEFT && (@direction == :UP || @direction == :DOWN) then @direction = :LEFT
      elsif dir == :RIGHT && (@direction == :UP || @direction == :DOWN) then @direction = :RIGHT 
      end
    end

    def check_collision

    end

  end

  class SnakeWindow < Gosu::Window
    def initialize
      super(WIDTH, HEIGHT, false, 6)
      self.caption = "Two Snakes"
      @snake = Snake.new(self, 30, 30)
      @food = place_food
    end

    def draw
      @snake.draw
    end

    def update
      @snake.move
      @snake.touching_self?
      #@snake.touching_other? nil
      @snake.touching_food? @food
      handle_keys 
    end

    def handle_keys
       if button_down? Gosu::KbUp then @snake.turn :UP
       elsif button_down? Gosu::KbDown then @snake.turn :DOWN
       elsif button_down? Gosu::KbLeft then @snake.turn :LEFT
       elsif button_down? Gosu::KbRight then @snake.turn :RIGHT
       end    
    end

    def place_food
      Segment.new(20, 10)
    end

  end

end

SnakeGame::SnakeWindow.new.show
