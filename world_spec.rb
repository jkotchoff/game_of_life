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

describe World do
  describe "#evolve!" do
    context "with a block-patterned still life" do
      subject do
        TwoDimensionalRectangularWorld.new(%Q{
          ....
          .xx.
          .xx.
          ....
        })
      end
  
      specify do
        subject.evolve!.to_s.should == %Q{
          ....
          .xx.
          .xx.
          ....
        }.gsub(/ /m, '')
      end
    end
  end
end

describe WorldState do
  describe "#cell_matching" do
    let(:three_horizontal_cells) do
      TwoDimensionalRectangularWorld.new(%Q{
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

describe Cell do
  describe "#evolve" do
    context "when a live cell with fewer then two live neighbours exists" do
      let(:zero_neighbours) { Cell.new(:state => true, :live_neighbour_count => 0) }
      specify{ zero_neighbours.evolve!.alive?.should == false }

      let(:one_neighbour)   { Cell.new(:state => true, :live_neighbour_count => 1) }
      specify{ one_neighbour.evolve!.alive?.should == false }
    end
  end
end

describe TwoDimensionalRectangularWorld do
  describe "#cells" do
    let(:two_horizontal_cells) do
      TwoDimensionalRectangularWorld.new(%Q{
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
      TwoDimensionalRectangularWorld.new(%Q{
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