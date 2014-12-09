module SnakeGame

  class MapReader

    def initialize file
      f = File.open(file, 'r')
    end


  end


end


SnakeGame::MapReader.new("map.dat")
