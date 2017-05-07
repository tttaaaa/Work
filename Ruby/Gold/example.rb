class Foo
 def foo
  "foo"
 end
end


class Bar < Foo
 def foo
  super + "bar"
 end
 alias bar foo
 undef foo
end
puts Bar.new.bar
