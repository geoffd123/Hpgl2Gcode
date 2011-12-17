require 'hpgl2gcode.rb'

describe "hpgl2gcode" do

  before(:each) do
    @uut = Hpgl2gcode.new
  end
  
  it "should output a g1 up command when PU received" do
    @uut.process(1, "PU;").should eql("G1 Z3\n")
  end

  it "should output a g21 g90 when IN received" do
    @uut.process(1, "IN;").should eql("G21\nG90\n")
  end

  it "should output a g1 down command when PD received" do
    @uut.process(1, "PD;").should eql("G1 Z0\n")
  end

  it "should output a g1 draw command when PA received" do
    @uut.process(1, "PA 959,1855;").should eql("G1 X23.975 Y46.375\n")
  end
  
  it "should output a g1 draw with 1mm X 2mm Y when PA received" do
    @uut.process(1, "PA 40,80;").should eql("G1 X1.0 Y2.0\n")
  end

end