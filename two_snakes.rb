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
      check_collision
      @segments = [Segment.new(x, y)] + @segments[0...@length]
    end

    def turn dir
      if dir == :UP && (@direction == :RIGHT || @direction == :LEFT) then @direction = :UP
      elsif dir == :DOWN  && (@direction == :RIGHT || @direction == :LEFT) then @direction = :DOWN
      elsif dir == :LEFT && (@direction == :UP || @direction == :DOWN) then @direction = :LEFT
      elsif dir == :RIGHT && (@direction == :UP || @direction == :DOWN) then @direction = :RIGHT 
      end
    end

    def grow
      @length += 1
    end

    def check_collision
      if @x < 0 || @y < 0 || @x * CELL_SIZE > WIDTH || @y * CELL_SIZE > HEIGHT then @window.game_status = :game_over end
    end

  end

  class SnakeWindow < Gosu::Window

    attr_accessor :game_status

    def initialize
      super(WIDTH, HEIGHT, false)
      self.caption = "Two Snakes"
      @snakes = [Snake.new(self, 10, 30), Snake.new(self, 30, 30)]
      @food = place_food
      @food_img = Gosu::Image.new(self, "food.png")
      @game_status = :on
    end

    def draw
      case @game_status
      when :on	      
        @snakes.each {|s| s.draw}
	@food_img.draw(@food.x * CELL_SIZE, @food.y * CELL_SIZE, 1) 
      when :game_over	
      end
    end

    def update
      case @game_status
      when :on	      
        @snakes.each {|s| s.move}
        #@snake.touching_self?
        #@snake.touching_other? nil
	@snakes.each do |s|
 	  if (s.touching_food? @food) 
	    s.grow
	    @food = place_food
	  end
	end
        handle_keys
      when :game_over
        handle_keys
      end	
    end

    def handle_keys
       case @game_status
       when :on	       
         if button_down? Gosu::KbUp then @snakes[0].turn :UP
         elsif button_down? Gosu::KbDown then @snakes[0].turn :DOWN
         elsif button_down? Gosu::KbLeft then @snakes[0].turn :LEFT
         elsif button_down? Gosu::KbRight then @snakes[0].turn :RIGHT
	 elsif button_down? Gosu::KbW then @snakes[1].turn :UP
         elsif button_down? Gosu::KbS then @snakes[1].turn :DOWN
         elsif button_down? Gosu::KbA then @snakes[1].turn :LEFT
         elsif button_down? Gosu::KbD then @snakes[1].turn :RIGHT
 	 
         elsif button_down? Gosu::KbEscape then exit
	 end
       when :game_over
        if button_down? Gosu::KbEscape then exit 
	elsif button_down? Gosu::KbR 
	  reset_game
	  @game_status = :on
	end
       end    
    end

    def place_food
      food_x = rand (WIDTH / CELL_SIZE - 5) + 2
      food_y = rand (HEIGHT / CELL_SIZE - 5) + 2      
      Segment.new(food_x, food_y)
    end

    def reset_game
      @snakes = [Snake.new(self, 10, 30), Snake.new(self, 30, 30)]
      @food = place_food
    end

  end

end
  
SnakeGame::SnakeWindow.new.show
