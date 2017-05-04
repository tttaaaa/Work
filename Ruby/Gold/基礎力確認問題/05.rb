class C
  aaa=0
  def aaa= v
    aaa=v
  end
  def aaa
    aaa
  end
end
begin
c = C.new
c.aaa=3
puts c.aaa
rescue => e
puts e.backtrace
