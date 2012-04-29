class Graph

  attr_reader :dwg

  def initialize
    @dwg = GraphViz.new(:G, :type => :digraph)
  end

  def build(name, tables, relations)
    config_graph(name)
    config_nodes
    config_edges

    tables.each do |table|
      @dwg.add_nodes(table)
    end

    relations.each do |relation|
      @dwg.add_edges(relation[1], relation[3])
    end
  end

  def output(name, format)
    case format
    when :pdf, nil
      filename = "#{name}.pdf"
      @dwg.output(:pdf => "#{filename}")
      puts "... Writing output #{filename}"
    when :dot
      filename = "#{name}.dot"
      @dwg.output(:dot => filename)
      puts "... Writing output #{filename}"
    else
      raise ArgumentError.new("Unknown output format #{format}")
      exit(1)
    end
  end

  private

  def config_graph(name)
    title = name.split('_').each{|s| s.capitalize!}.join(' ')
    date = Time.now
    @dwg.graph[:labelloc]  = "t"
    @dwg.graph[:label]     = "#{title} Database\nGenerated #{date}"
    @dwg.graph[:fontname]  = "Helvetica"
    @dwg.graph[:fontcolor] = "#666666"
    @dwg.graph[:fontsize]  = "24"
  end

  def config_nodes
    @dwg.node[:color]     = "#222222"
    @dwg.node[:style]     = "filled"
    @dwg.node[:shape]     = "box"
    @dwg.node[:penwidth]  = "1"
    @dwg.node[:fontname]  = "Helvetica"
    @dwg.node[:fillcolor] = "#eeeeee"
    @dwg.node[:fontcolor] = "#333333"
    @dwg.node[:margin]    = "0.05"
    @dwg.node[:fontsize]  = "12"
  end

  def config_edges
    @dwg.edge[:color]      = "#666666"
    @dwg.edge[:weight]     = "1"
    @dwg.edge[:fontsize]   = "10"
    @dwg.edge[:fontcolor]  = "#444444"
    @dwg.edge[:fontname]   = "Helvetica"
    @dwg.edge[:dir]        = "forward"
    @dwg.edge[:arrowsize]  = "0.5"
    @dwg.edge[:arrowhead]  = "crow"
  end
end