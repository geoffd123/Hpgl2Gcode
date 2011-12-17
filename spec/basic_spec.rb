require './lib/hpgl2gcode/gcode.rb'
require './lib/hpgl2gcode/options'

describe "hpgl2gcode" do

  before(:each) do
    @uut = Hpgl2gcode.new
  end
  
  context "Generating GCode" do
    
    it "should output a g1 up command when PU received" do
      @uut.process_cmdline(["-t", "4"])
      @uut.process(1, "PU;").should eql("G1 Z3.0\n")
    end
  
    it "should output a g21 g90 when IN received" do
      @uut.process(1, "IN;").should eql("G21\nG90\n")
    end
  
    it "should output a g1 down command when PD received" do
      @uut.process_cmdline(["-c", "4"])
      @uut.process(1, "PD;").should eql("G1 Z0.0\n")
    end
  
    it "should output a g1 draw command when PA received" do
      @uut.process(1, "PA 959,1855;").should eql("G1 X23.975 Y46.375\n")
    end
    
    it "should output a g1 draw with 1mm X 2mm Y when PA received" do
      @uut.process(1, "PA 40,80;").should eql("G1 X1.0 Y2.0\n")
    end
  
    it "should set the correct Z value when a thickness parameter has been set" do
      @uut.process_cmdline(['-t', '2.5'])
      @uut.process(1, "PD;").should eql("G1 Z2.5\n")
    end
  
    it "should set the correct Z value when a z_clear parameter has been set" do
      @uut.process_cmdline(['-c', '6.5'])
      @uut.process(1, "PU;").should eql("G1 Z6.5\n")
    end
  end
  
  context "Parse commandline correctly" do
    it "should parse a -t correctly" do
      opts = Options.new(["-t", "0.5"])
      opts.thickness.should eql(0.5)      
    end
    
    it "should parse a --thickness correctly" do
      opts = Options.new(["--thickness", "1.5"])
      opts.thickness.should eql(1.5)      
    end
    
    it "should parse a -c correctly" do
      opts = Options.new(["-c", "2.5"])
      opts.z_clear.should eql(2.5)      
    end
    
    it "should parse a --z_clearance correctly" do
      opts = Options.new(["--z_clearance", "3.5"])
      opts.z_clear.should eql(3.5)      
    end
  end
end
