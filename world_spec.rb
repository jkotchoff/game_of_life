@library_call = true

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
          }).evolve!.to_s.trim_whitespace!.should == %Q{
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
          }.trim_whitespace!
        end

        let(:horizontal_blinker) do
          %Q{
            . . . . .
            . . . . .
            . x x x .
            . . . . .
            . . . . .
          }.trim_whitespace!
        end
        
        it "rotates sideways" do
          TwoDimensionalRectangularWorld.new(vertical_blinker).evolve!.to_s.trim_whitespace!.should == horizontal_blinker
        end
  
        it "rotates sideways" do
          TwoDimensionalRectangularWorld.new(horizontal_blinker).evolve!.to_s.trim_whitespace!.should == vertical_blinker
        end
        
        it "two rotations send it back to the original state" do
          TwoDimensionalRectangularWorld.new(vertical_blinker).evolve!.evolve!.to_s.trim_whitespace!.should == vertical_blinker
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
  describe "#evolved_state" do
    def make_live_cell(live_neighbour_count)
      Cell.new(:state => true).tap do |cell|
        cell.stub!(:live_neighbour_count).and_return(live_neighbour_count)
      end
    end
    
    context "when alive with fewer then two live neighbours" do
      let(:zero_neighbour_cell) { make_live_cell(0) }
      it "dies, as if caused by under-population" do
        zero_neighbour_cell.evolved_state.should == false
      end

      let(:one_neighbour_cell)   { make_live_cell(1) }
      it "dies, as if caused by under-population" do
        one_neighbour_cell.evolved_state.should == false
      end
    end

    context "when alive with two or three live neighbours" do
      let(:two_neighbour_cell) { make_live_cell(2) }
      it "lives on to the next generation" do
        two_neighbour_cell.evolved_state.should == true
      end

      let(:three_neighbour_cell) { make_live_cell(3) }
      it "lives on to the next generation" do
        three_neighbour_cell.evolved_state.should == true
      end
    end

    context "when alive with more than three live neighbours" do
      (4..8).each do |live_neighbour_count|
        subject{ make_live_cell(live_neighbour_count) }
        it "dies, as if caused by overcrowding" do
          subject.evolved_state.should == false
        end
      end
    end
    
    context "when dead with exactly three live neighbours" do
      let(:three_neighbour_dead_cell) do
        Cell.new(:state => false).tap do |cell|
          cell.stub!(:live_neighbour_count).and_return(3)
        end
      end
      it "becomes a live cell, as if by reproduction" do
        three_neighbour_dead_cell.evolved_state.should == true
      end
    end
  end
end

describe TwoDimensionalRectangularWorld do
  describe "#to_s" do
    subject do
      TwoDimensionalRectangularWorld.new(%Q{
        . . . . .
        . . x . .
        . . x . .
        . . x . .
        . . . . .
      }).to_s.trim_whitespace!
    end

    it "dumps the current state of the world into a string that can be printed" do
      subject.should == %Q{
        . . . . .
        . . x . .
        . . x . .
        . . x . .
        . . . . .
      }.trim_whitespace!
    end
  end
end