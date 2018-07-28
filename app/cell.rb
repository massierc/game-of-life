class Cell
  attr_accessor :x, :y, :value

  def initialize(args)
    @x = args[:x]
    @y = args[:y]
    @value = args[:value]
    @state = nil
  end

  def neighbours(world)
    arr = world.map { |row| row.map(&:value) }
    rows = coords(arr[0], @x)[:start]..coords(arr[0], @x)[:stop]
    cols = coords(arr, @y)[:start]..coords(arr, @y)[:stop]
    n = sub_array(arr, rows, cols)
  end

  def next_state(world)
    sum = self.neighbours(world).flatten.reduce(:+) - self.value
    if sum < 2 || sum > 3
      self.value = 0
    elsif self.value == 1 && (sum == 2 || sum == 3)
      self.value = 1
    elsif self.value == 0 && sum == 3
      self.value = 1
    end
    self
  end
end

def coords(arr, el)
  el == 0 ? start = 0 : start = el - 1
  el == arr.length ? stop = el : stop = el + 1
  coord = {start: start, stop: stop}
end

def sub_array(arr, rows, columns)
  arr[rows].map { |row| row[columns] }
end
