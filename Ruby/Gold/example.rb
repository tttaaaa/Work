class Hoge
  def initialize(a)
    p "init"
    p a
  end
  def second(b)
    initialize(b)
  end
end
first =Hoge.new(1)
second = Hoge.new(2)
#first.initialize(3)
second.second(3)
