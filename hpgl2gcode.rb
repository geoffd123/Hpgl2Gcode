class String
  
  def starts_with?(prefix)
    prefix = prefix.to_s
    self[0, prefix.length] == prefix
  end
end


def process(l)
  if l.starts_with?('PU') 
    puts("G1 Z6\n")
  elsif l.starts_with?('PD') 
    puts("G1 Z3\n")
  elsif l.starts_with?('PA') 
    pos = l.match(/(\w+),(\w+);/)
    # p pos
    x = pos[1].to_f/40.0
    y = pos[2].to_f/40.0
    print("G1 X#{x} Y#{y}\n")
  elsif l.starts_with? 'IN'
  elsif l.starts_with? 'IP'
  elsif l.starts_with? 'SP'
  elsif l.starts_with? 'SC'
  elsif l.starts_with? 'AA'
    print("G1 Z20\nG1 Z0\n")
  elsif l.empty?
  else 
    print("; '#{l}' : is not handled ---------------------------\n")
  end
   
end


lines = IO.readlines("./test.hpgl", ";")
lines.each{|l| 
  process(l.strip)
}