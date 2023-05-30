require 'pry'

class A
  def hello() 
    puts "hello world!" 
  end
end

a = A.new

binding.pry

puts "program resumes here."