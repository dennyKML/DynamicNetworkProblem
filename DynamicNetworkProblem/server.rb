class Server
  attr_accessor :nodes, :max_load

  def initialize(max_load)
    @nodes = []
    @max_load = max_load
  end

  def current_load
    @nodes.sum(&:load)
  end

  def add_node(node)
    if current_load + node.load <= max_load
      @nodes << node
      true
    else
      false
    end
  end

  def overloaded?
    current_load >= max_load * 0.5
  end
end