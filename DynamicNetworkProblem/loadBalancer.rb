require_relative 'node'
require_relative 'server'

class LoadBalancer
  attr_accessor :servers

  def initialize(servers_max_load)
    @servers = servers_max_load.map { |max_load| Server.new(max_load) }
  end

  def distribute_node(node)
    # Знайдемо сервер із найменшим завантаженням, що зможе витримати навантаження вузла, а також він не є перевантаженим
    suitable_server = @servers.select { |server| server.current_load + node.load <= server.max_load && !server.overloaded? }.min_by(&:current_load)

    # Якщо підходящого серверу не було знайдено
    if suitable_server.nil?
      puts "All servers are overloaded!"
      puts "\tLoad of a node that failed to connect: #{node.load}"
      return
    end

    # Додаємо вузол на незавантажений сервер
    suitable_server.add_node(node)

    # Якщо сервер було переповнено, то розкинемо його вузли по іншим серверам
    redistribute_nodes(suitable_server) if suitable_server.overloaded?
  end

  def redistribute_nodes(overloaded_server)
    overloaded_server.nodes.each do |node|
      overloaded_server.nodes.delete(node)
      distribute_node(node)
    end
  end

  def print_loads_and_nodes
    @servers.each_with_index do |server, index|
      puts "Server #{index}, Load: #{server.current_load} out of #{server.max_load}"
      server.print_nodes
    end
  end

end
