require './app/cell'

class Life
  attr_accessor :world, :previous_world, :original_world

  def initialize(width, height, live_cells)
    flat_world = Array.new(width * height).map { |cell| cell = Cell.new(value: 0) }
    live_cells.times { |i| flat_world[i].value = 1 }
    @world = flat_world.shuffle.each_slice(width).to_a
    @world.each_with_index.map do |row, i| 
      row.each_with_index.map do |cell, j|
        cell.y = j
        cell.x = i
      end
    end
    @original_world = @world.dup
  end

  def new_cycle
    @previous_world = @world.dup
    new_world = []
    @world.each_with_index do |row, i|
      new_row = []
      row.each_with_index do |cell, j|
         new_row << cell.dup.next_state(@world)
      end
      new_world << new_row
    end
    @world = new_world
  end

  def live_cell_count(world)
    world.flatten.map { |cell| cell.value }.reduce(:+)
  end

  def print_matrix(array)
    alphabet = ('A'..'Z').to_a
    array.each_with_index do |row, i|
      width = row.length
      if i == 0
        width.times do |k|
          if k == 0
            print "    #{alphabet[k]}"
          elsif k == width - 1
            puts " #{alphabet[k]}"        
          else
            print " #{alphabet[k]}"        
          end
        end
      end
      print " #{alphabet[i]} "
      cells = row.each_with_index.map do |cell, j|
        if j == width - 1
          cell.value == 1 ? "|*|" : "| |"
        else
          cell.value == 1 ? "|*" : "| "
        end
      end
      puts cells.join("")
    end
  end
end