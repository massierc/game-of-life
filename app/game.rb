require 'colorize'
require './app/cell'
require './app/life'

class Game
  def play
    clear
    setup
    puts "Original world:"
    print_world
    print_footer
    @lifecycles = 1
    @life.new_cycle
    while alive && life_evolving do
      clear
      puts "New world:"
      print_world
      print_footer
      @lifecycles += 1
      @life.new_cycle
    end
    end_game
  end

  def setup
    puts "World size (defaults to 10x10, max 26x26):"
    input = gets.chomp
    if input.empty?
      size = [10, 10]
    else
      size = input.scan(/\d+/).map { |x| x.to_i < 27 ? x.to_i : 26 }
    end
    width = size[0]
    size[1] ? height = size[1] : height = size[0]
    max_cells = width * height
    clear
    puts "Transition speed: (defaults to 0)"
    input = gets.chomp
    input.empty? ? @transition = 0 : @transition = input.to_f
    clear
    default_cells = max_cells / 2
    puts "Live cells (defaults to #{default_cells}, max #{max_cells}):"
    input = gets.chomp
    if input.empty?
      live_cells = default_cells
    else
      input.to_i > max_cells ? live_cells = max_cells : live_cells = input.to_i
    end
    @life = Life.new(width, height, live_cells)
    clear
  end

  def life_evolving
    @life.world.flatten.map(&:value) != @life.previous_world.flatten.map(&:value)
  end

  def alive
    @life.live_cell_count(@life.world) > 0
  end

  def print_world
    puts ""
    @life.print_matrix(@life.world)
  end

  def print_footer
    text = "\nLive cells: #{@life.live_cell_count(@life.world)}\n"
    text += "Total lifecycles: #{@lifecycles}\n\n"
    puts text
    sleep(@transition)
  end

  def end_game
    puts "\n"
    if alive
      text =  "                                    \n"
      text += "              CONGRATS              \n"
      text += "                                    \n"
      text += "   You have reached optimal life!   \n"
      text += "                                    \n"
      text += "                                    \n"
      puts text.colorize(:white).colorize(background: :green)
    else
      text =  "                              \n"
      text += "             OUCH             \n"
      text += "                              \n"
      text += "   The apocalypse has come!   \n"
      text += "                              \n"
      text += "                              \n"
      puts text.colorize(:white).colorize(background: :red)
    end
    text = "\n"
    text += "Original world:\n\n"
    puts text
    @life.print_matrix(@life.original_world)
    text = "\nLive cells: #{@life.live_cell_count(@life.original_world)}\n\n"
    puts text
  end

  def clear
    system "clear"
    puts ""
  end
end
