module IntegerComputation
  def gcd x,y
    puts "input is " + x.to_s +  "and" + y.to_s
      x = -x if x < 0
      y = -y if y < 0
      return x if x == y
      until x == 0 || y == 0 do
        x = x % y if y < x
        return y if x == 0
        y = y % x if y > x
        return x if y == 0
      end
  end
  module_function :gcd
end
#include IntegerComputation
puts IntegerComputation.gcd(3,6)
puts IntegerComputation.gcd(500321,77)
