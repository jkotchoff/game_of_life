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

        # Determine how many neighbours are alive
        up = row_index > 0
        right = cell_index + 1 < self.width
        down = row_index + 1 < self.height
        left = cell_index > 0
        neighbours = []
        neighbours << rows[row_index - 1].chars.collect[cell_index - 1] if up   && left
        neighbours << rows[row_index - 1].chars.collect[cell_index]     if up           
        neighbours << rows[row_index - 1].chars.collect[cell_index + 1] if up   && right
        neighbours << row.chars.collect[cell_index + 1]                 if         right
        neighbours << rows[row_index + 1].chars.collect[cell_index + 1] if down && right
        neighbours << rows[row_index + 1].chars.collect[cell_index]     if down         
        neighbours << rows[row_index + 1].chars.collect[cell_index - 1] if down && left
        neighbours << row.chars.collect[cell_index - 1]                 if         left
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
