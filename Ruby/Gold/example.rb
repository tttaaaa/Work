def hoge (x:, y: 2, **params)
  puts "#{x},#{y},#{params[:z]}"
  puts params.class
  puts params
  puts x.class
end
hoge x: 1, z: 3
