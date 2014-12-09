require 'gosu'

module SnakeGame

  Segment = Struct.new(:x, :y)
  WIDTH = 640
  HEIGHT = 480
  CELL_SIZE = 2

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
      @segments << Segment.new(x, y)
      @segments = @segments.reverse[0..(length-1)]

    end

    def turn key

    end

    def check_collision

    end

  end

  class SnakeWindow < Gosu::Window
    def initialize
      super(WIDTH, HEIGHT, false, 6)
      self.caption = "Two Snakes"
      @snake = Snake.new(self, 30, 30)
      place_food
    end

    def draw
      @snake.draw
    end

    def update
      @snake.move
      @snake.check_collision
    end

    def place_food

    end

  end

end

SnakeGame::SnakeWindow.new.show
