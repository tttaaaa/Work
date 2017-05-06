require "optparse"

#文字列入力の場合
inputstring = "close each fileno inspect path to_path pos tell pos= seek read rewind"

linkinput = []
linktarget = []

opt = OptionParser.new
options={}
opt.on("-o var","--output","output file"){|var| options["output"] = var}
opt.on("-i var","--input","input file"){|var| options["input"] = var}
opt.parse!(ARGV)
p options

#  File.open(options["input"],"r") do |line|
#    inputstring + line.
#  end

# 出力に整形
inputstring.split(" ").each do |str|
  before_output = "[" +str + "](#" + str +") <br> "
  linkinput << before_output
  after_output = '#### <a name="' + str + '"> ' + str
  linktarget << after_output
end

file = File.open(options["output"],"a")
linkinput.each do |str|
  file.print(str)
end
file.puts("")
linktarget.each do |str|
  file.puts(str)
end
file.close
