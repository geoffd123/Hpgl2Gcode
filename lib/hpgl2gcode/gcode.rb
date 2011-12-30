


class String
  
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end

class Hpgl2gcode
  
  attr_accessor :pendown
  
  def hp2mm(value)
    if (value.class == String)
      value = value.to_f
    end
  
    value/40.0
  end

    def limit_acc(n)
      r = (n * 1000.0) + 1.0
      r = r.round
      r = r / 1000.0
      r
    end
    
    def plot_polycircle(x_centre, y_centre, arc_degrees)
      result = ""
      rad = (((x_centre - @current_x) * (x_centre - @current_x)) + ((y_centre - @current_y) * (y_centre - @current_y))) ** 0.5
      
      rad = limit_acc(rad)
    
      result += "G1 X#{x_centre} Y#{y_centre}\n"
      
      pi = 3.141
      
      0.step((arc_degrees.to_f/360.0) * 2.0 * pi, 2.0 * pi / 15.0) {|i|
        result += "G1 X#{limit_acc(x_centre + rad * Math.cos(i))} Y#{limit_acc(y_centre+rad*Math.sin(i))} F#{@opts.feedrate}\n"
      }
      result
    end
    
    def process(line_num, l)
      begin
        if l.starts_with?('PU')
          @pendown = false 
          return("G1 Z#{@opts.z_clear} F#{@opts.zrate}\n")
          
        elsif l.starts_with?('PD')
          @pendown = true 
          return("G1 Z#{@opts.thickness} F#{@opts.zrate}\n")
        elsif l.starts_with?('PA') 
          pos = l.match(/(\w+),(\w+);/)
          # p pos
          @current_x = hp2mm(pos[1])
          @current_y = hp2mm(pos[2])
          fr = (@pendown) ? @opts.feedrate : @opts.travelrate
          return ("G1 X#{@current_x} Y#{@current_y} F#{fr}\n")
        elsif l.starts_with? 'IN'
          @pendown = true
          return "G21\nG90\nG1 Z#{@opts.z_clear} F#{@opts.zrate}\n"
        elsif l.starts_with? 'IP'
        elsif l.starts_with? 'SP'
        elsif l.starts_with? 'SC'
        elsif l.starts_with? 'AA'
          pos = l.match(/([0-9.-]+),([0-9.-]+),([0-9.-]+);/)
          return plot_polycircle(hp2mm(pos[1]), hp2mm(pos[2]), pos[3].to_i)
        elsif l.empty?
        else 
          $stderr.print("Line #{line_num}: '#{l}' : is not handled\n")
        end
        return ""
      rescue Exception => e
        $stderr.print("Exception #{e.message} occurred on line #{line_num} HPGL: #{l}\n")
      end
    end
    
    
    def process_cmdline args
      @opts = Options.new(args)
    end
    
     def execute
      process_cmdline(ARGV)
 
      outfile = File.open(@opts.output_filename, "w")
      lines = IO.readlines(@opts.input_filename, ";")
      lines.each_with_index{|l, i| 
        r = process(i, l.strip)
        outfile.print r unless r.nil? || r.empty?
      }
      outfile.close
    end
end

# app = Hpgl2gcode.new
# app.execute()
 