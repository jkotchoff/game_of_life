# modify ruby Array behaviour to return nil if the specified index is outside it's bounds
=begin
#TODO: 
class Array
  def [](index)
    return nil if index < 0
    super(index-1)
  end
end
=end

WorldState = Struct.new :cells do
  def cell_matching(other_cell)
    cells.each do |cell| 
      return cell if cell.position == other_cell.position
    end
  end
end

Cell = Struct.new :state, :position, :live_neighbour_count do
  def initialize(h={})
    members.each {|m| self[m] = h[m.to_sym]}
  end
  
  def alive?
    !!state
  end
  
  def evolve
    state = false if live_neighbour_count < 2
  end
  
  def to_s
    alive? ? 'x' : '.'
  end
end

class World
  attr_accessor :current_state
  
  def cells
    current_state.cells
  end

  def evolve
    self.current_state = self.current_state.dup.tap do |evolved_state|
      evolved_state.cells.each do |new_cell| 
        new_cell.state = current_state.cell_matching(new_cell).evolve
      end
    end
  end
end

class TwoDimensionalWorld < World
  ALIVE = 'x'             # used to parse input strings
  attr_accessor :height   # used for visualizing to_s
  attr_accessor :width    # used for neighbour checking bounds
  
  def initialize(initial_state)
    rows = initial_state.split("\n").collect(&:trim).reject(&:blank?)
    self.height = rows.length
    self.width = nil
    cells = []
    rows.each_with_index do |row, row_index|
      self.width ||= row.length
      row.each_char.each_with_index do |char, cell_index|
        
        neighbours = []
        
        # Check row above
        if row_index > 0
          row_above = rows[row_index - 1]

          if cell_index > 0 
            # Check up-left
            neighbours << row_above.chars.collect[cell_index - 1]
          end

          # Check up
          neighbours << row_above.chars.collect[cell_index]

          if cell_index + 1 < self.width
            # Check up-right
            neighbours << row_above.chars.collect[cell_index + 1]
          end
        end
        
        # Check right
        if cell_index + 1 < self.width
          # Check right
          neighbours << row.chars.collect[cell_index + 1]
        end

        # Check row below
        if row_index + 1 < self.height
          row_below = rows[row_index + 1]

          if cell_index > 0 
            # Check down-left
            neighbours << row_below.chars.collect[cell_index - 1]
          end

          # Check down
          neighbours << row_below.chars.collect[cell_index]

          if cell_index + 1 < self.width
            # Check down-right
            neighbours << row_below.chars.collect[cell_index + 1]
          end
        end

        if cell_index > 0 
          # Check left
          neighbours << row.chars.collect[cell_index - 1]
        end
        
        live_neighbour_count = neighbours.compact.select{|neighbour| neighbour == ALIVE}.length

        cells << Cell.new(
          :state => (char == ALIVE), 
          :position => {
            :row => row_index, 
            :column => cell_index
          },
          :live_neighbour_count => live_neighbour_count
        )
      end
    end
    self.current_state = WorldState.new(cells)
  end
  
  def to_s
    str = ''
    cells.each_with_index do |cell, i|
      str += "\n" if i % height == 0
      str += cell.to_s
    end
    str + "\n"
  end
end
