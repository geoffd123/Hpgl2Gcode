require 'pathname'
require 'optparse'

#module Hpgl2gcode

  class Options
    
    DEFAULT_THICKNESS = 0.0
    DEFAULT_Z_CLEAR = 3.0
    
    attr_reader :input_filename
    attr_reader :output_filename
    attr_reader :thickness
    attr_reader :z_clear
    
    def initialize(argv)
      @thickness = DEFAULT_THICKNESS
      @z_clear = DEFAULT_Z_CLEAR
      @input_filename = "";
      parse(argv)
    end
  
  private
  
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: hpgl2gcode [ option]"
        
        opts.on("-t =value", "--thickness =value", Float, "Board thickness (default 0.0)") do |thickness|
          @thickness = thickness
        end
        
        opts.on("-c =value", "--z_clearance =value", Float, "Z Height for pen to clear board (default 3.0mm)") do |z_clear|
          @z_clear = z_clear
        end
        
        opts.on("-i =path", "--input =path", String, "Path to input (hpgl)") do |fn|
          @input_filename = fn
        end
        
        opts.on("-o =path", "--output =path", String, "Path to output (gcode) defaults to input file with .gcode extension") do |fn|
          @output_filename = fn
        end
        
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        
        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
          if @input_filename.empty?
            print("You must specify an input file\n")
            exit(-1)
          end
          
          if @output_filename.nil? || @output_filename.empty?
            # replace .hpgl with .gcode
            input_path = Pathname.new(@input_filename)
            extn = input_path.extname
            pa = input_path.split
            pa[pa.count-1] = pa[pa.count-1].sub(extn, ".gcode")
            po = Pathname.new(pa.join('/'))
            @output_filename = po.cleanpath.to_s
          end
        rescue OptionParser::ParseError => e
              STDERR.puts e.message, "\n", opts
              exit(-1)
        end
        
      end
    end
  end
#end
