require 'optparse'

#module Hpgl2gcode

  class Options
    
    DEFAULT_THICKNESS = 0.0
    DEFAULT_Z_CLEAR = 3.0
    
    attr_reader :outfile_name
    attr_reader :thickness
    attr_reader :z_clear
    
    def initialize(argv)
      @thickness = DEFAULT_THICKNESS
      @z_clear = DEFAULT_Z_CLEAR
      parse(argv)
    end
  
  private
  
    def parse(argv)
      OptionParser.new do |opts|
        opts.banner = "Usage: hpgl2gcode [ option] "
        opts.on("-t", "--thickness value", Float, "Board thickness") do |thickness|
          @thickness = thickness
        end
        opts.on("-c", "--z_clearance value", Float, "Z Height for pen to clear board") do |z_clear|
          @z_clear = z_clear
        end
        opts.on("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        begin
          argv = ["-h"] if argv.empty?
          opts.parse!(argv)
        rescue OptionParser::ParseError => e
              STDERR.puts e.message, "\n", opts
              exit(-1)
        end
        
      end
    end
  end
#end
