require 'world'
require 'ruby-debug'

describe World do
  describe "#evolve!" do
    describe "patterns" do
      context "with a block still life" do
        it "doesn't change state" do
          TwoDimensionalRectangularWorld.new(%Q{
            . . . .
            . x x .
            . x x .
            . . . .
          }).evolve!.to_s.should == %Q{
            . . . .
            . x x .
            . x x .
            . . . .
          }.trim_whitespace!
        end
      end
  
      context "with a blinkered oscillator" do
        let(:vertical_blinker) do
          %Q{
            . . . . .
            . . x . .
            . . x . .
            . . x . .
            . . . . .
          }          
        end

        let(:horizontal_blinker) do
          %Q{
            . . . . .
            . . . . .
            . x x x .
            . . . . .
            . . . . .
          }
        end
        
        it "rotates sideways" do
          TwoDimensionalRectangularWorld.new(vertical_blinker).evolve!.to_s.should == horizontal_blinker.trim_whitespace!
        end
  
        it "rotates sideways" do
          TwoDimensionalRectangularWorld.new(horizontal_blinker).evolve!.to_s.should == vertical_blinker.trim_whitespace!
        end
      end
    end
  end
end

describe WorldState do
  describe "#cell_matching" do
    let(:three_horizontal_cells) do
      TwoDimensionalRectangularWorld.new(%Q{
        . x .
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
    def make_live_cell(live_neighbour_count)
      Cell.new(:state => true, :live_neighbour_count => live_neighbour_count)
    end
    
    context "when alive with fewer then two live neighbours" do
      let(:zero_neighbour_cell) { make_live_cell(0) }
      it "dies, as if caused by under-population" do
        zero_neighbour_cell.evolve!.alive?.should == false
      end

      let(:one_neighbour_cell)   { make_live_cell(1) }
      it "dies, as if caused by under-population" do
        one_neighbour_cell.evolve!.alive?.should == false
      end
    end

    context "when alive with two or three live neighbours" do
      let(:two_neighbour_cell) { make_live_cell(2) }
      it "lives on to the next generation" do
        two_neighbour_cell.evolve!.alive?.should == true
      end

      let(:three_neighbour_cell) { make_live_cell(3) }
      it "lives on to the next generation" do
        three_neighbour_cell.evolve!.alive?.should == true
      end
    end

    context "when alive with more than three live neighbours" do
      (4..8).each do |live_neighbour_count|
        subject{ make_live_cell(live_neighbour_count) }
        it "dies, as if caused by overcrowding" do
          subject.evolve!.alive?.should == false
        end
      end
    end
    
    context "when dead with exactly three live neighbours" do
      let(:three_neighbour_dead_cell) { Cell.new(:state => false, :live_neighbour_count => 3) }
      it "becomes a live cell, as if by reproduction" do
        three_neighbour_dead_cell.evolve!.alive?.should == true
      end
    end
  end
end

describe TwoDimensionalRectangularWorld do
  describe "#cells" do
    let(:two_horizontal_cells) do
      TwoDimensionalRectangularWorld.new(%Q{
        . .
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
        . . . . .
        . . x . .
        . . x . .
        . . x . .
        . . . . .
      })
    end

    it "dumps the current state of the world into a string that can be printed" do
      subject.to_s.should == %Q{
        . . . . .
        . . x . .
        . . x . .
        . . x . .
        . . . . .
      }.trim_whitespace!
    end
  end
end