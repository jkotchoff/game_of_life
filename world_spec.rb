require 'world'
require 'ruby-debug'

class String
  def trim
    self.gsub(/ /m, '')
  end

  def blank?
    self == ''
  end
end

describe WorldState do
  describe "#cell_matching" do
    let(:three_horizontal_cells) do
      World::TwoDimensionalWorld.new(%Q{
        .x.
      })
    end
    let(:three_cell_duplicate){ three_horizontal_cells.current_state.dup }
    let(:duplicate_active_cell){ three_cell_duplicate.cells[1] }
    
    it "returns the cell in the same position as the provided cell" do
      three_horizontal_cells.current_state.cell_matching(duplicate_active_cell).alive?.should be_true
    end
  end
end

describe World do
  describe "#evolve" do
    context "when a live cell with fewer then two live neighbours exists" do
      let(:world) {
        World::TwoDimensionalWorld.new(%Q{
          ...
          .x.
          ...
        })        
      }
      before do
        world.evolve
        @evolved_world = world.to_s
      end

      it "kills the live cell" do
        @evolved_world.should == %Q{
          ...
          ...
          ...
        }.gsub(/ /m, '')
      end
    end
  end
end

describe World::TwoDimensionalWorld do
  describe "#cells" do
    let(:two_horizontal_cells) do
      World::TwoDimensionalWorld.new(%Q{
        ..
      })
    end

    it "returns cells that can be evolved based on rules" do
      two_horizontal_cells.current_state.cells.should == [
        Cell.new(
          :state => false, 
          :position => {
            :row => 0, 
            :column => 0
          }, 
          :live_neighbour_count => 0
        ),
        Cell.new(
          :state => false, 
          :position => {
            :row => 0, 
            :column => 1
          }, 
          :live_neighbour_count => 0
        )
      ]
    end
  end

  describe "#to_s" do
    subject do
      World::TwoDimensionalWorld.new(%Q{
        .....
        ..x..
        ..x..
        ..x..
        .....
      })
    end

    it "dumps the current state of the world into a string that can be printed" do
      subject.to_s.should == %Q{
        .....
        ..x..
        ..x..
        ..x..
        .....
      }.gsub(/ /m, '')
    end
  end
end