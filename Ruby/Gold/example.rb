require "optparse"
require "time"

OptionParser.accept(Time) do |s,|
  begin
    puts "Time.parse"
    puts Time.parse(s) if s
  rescue
    raise OptionParser::InvalidArgument, s
  end
end

opts = OptionParser.new

opts.on("-t", "--time [TIME]", Time) do |time|
  p time.class #=> Time
end

puts ARGV
opts.parse!(ARGV)
