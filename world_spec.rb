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
    before{ pending }
    context "when a live cell with fewer then two live neighbours exists" do
      subject do
        World::TwoDimensionalWorld.new(%Q{
          ...
          .x.
          ...
        }).evolve.to_s
      end

      it "kills the live cell" do
        subject.should == %Q{
          ...
          ...
          ...
        }
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
        Cell.new(:state => false, :position => {:row => 0, :column => 0}),
        Cell.new(:state => false, :position => {:row => 0, :column => 1})
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