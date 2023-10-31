require_relative 'node'
require_relative 'server'
require_relative 'loadBalancer'

# Створимо новий балансувальний навантаження з серверами
balancer = LoadBalancer.new([100, 150, 200])

# Створимо вузли з різними навантаженнями
nodes = [10, 20, 30, 40, 50, 60, 70, 80, 90].map { |load| Node.new(load) }

puts "The load of nodes trying to connect: #{nodes.map(&:load)}\n\n"

# Виведемо навантаження серверів до розподілу вузлів і після
puts "Before distribution:"
balancer.print_loads_and_nodes
puts

nodes.each do |node|
  balancer.distribute_node(node)
end

puts "\nAfter distribution:"
balancer.print_loads_and_nodes
