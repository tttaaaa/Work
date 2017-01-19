# Daily Log
require 'fileutils'


puts "hello Daily Log"
puts Time.now.strftime("%Y-%m-%d %H:%M")
today = Time.now.strftime("%Y%m%d")
FileUtils.mkdir_p("./log")
@target_file = "./log/" + today + ".md"
File.open(@target_file,"a") do |file|
  file.puts "program is started at " + today
end
@start_time = Time.now.strftime("%H%M").to_i

def add (input)
  File.open(@target_file,"a") do |file|
    file.puts Time.now.strftime("%Y-%m-%d %H:%M") + input
  end
end

def add_content ( input )
  File.open(@target_file,"a") do |file|
    file.puts Time.now.strftime("%Y-%m-%d %H:%M") + "work_theme is the following"
    file.puts "## " + input
  end
end

input = ""
until input == "e" do
  puts "========================="
  puts "select the status"
  puts "[c]: 集中!"
  puts "[u]: うるさい!"
  puts "[s]: 中断"
  puts "[r]: 再開"
  puts "[e]: 終了"
  puts "[p]　完璧にできた．"
  puts "[1]: 作業内容を入力"
  puts "========================="

  input = gets.to_s.chomp

  case input
  when "c"
    add  "集中!"
  when "u"
    add  "うるさい！うるさい！うるさーい！"
  when "s"
    add  "中断.切り替えも大事ですね"
    @end_time = Time.now.strftime("%H%M").to_i
    if @start_time
    work_time =   @end_time - @start_time
    puts "作業時間は" + work_time.to_s + "分でした．"
  end
  when "r"
    add "再開だ！"
    @start_time = Time.now.strftime("%H%M").to_i
  when "e"
    add "終了"
    @end_time = Time.now.strftime("%H%M").to_i
    if @start_time
    work_time =   @end_time - @start_time
    puts "作業時間は" + work_time.to_s + "分でした．"
    end
  when "1"
    puts "作業内容を入力してください"

    @work_theme = gets.to_s.chomp
    @work_theme.encode!("utf-8")
    puts @work_thme
    add_content (@work_theme)
    @start_time = Time.now.strftime("%H%M").to_i
  else
    puts "入力は正しくしようぜ"
  end
end
