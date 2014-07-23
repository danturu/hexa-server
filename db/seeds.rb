puts "Creating universe from nothing..."

plots = Hash.new
plots["x"] = { object: Plot.create(tag: "stone", char: "x", color: "white") }

units = Hash.new
units["W"] = { object: Unit.create(tag: "white", char: "W", color: "green"), metadata: { owner: "white" } }
units["B"] = { object: Unit.create(tag: "black", char: "B", color: "red"),   metadata: { owner: "black" } }

puts "Creating Cancer planet..."

plots_map = <<-map
- | - | x | - | -
| - | x | x | - |
- | x | x | x | -
| x | x | x | x |
x | x | x | x | x
| x | x | x | x |
x | x | x | x | x
| x | x - x | x |
x | x | x | x | x
| x | - | - | x |
x | x | x | x | x
| x | x | x | x |
x | x | x | x | x
| x | x | x | x |
- | x | x | x | -
| - | x | x | - |
- | - | x | - | -
map

units_map = <<-map
- | - | W | - | -
| - | x | x | - |
- | x | x | x | -
| x | x | x | x |
B | x | x | x | B
| x | x | x | x |
x | x | x | x | x
| x | x - x | x |
x | x | x | x | x
| x | - | - | x |
x | x | x | x | x
| x | x | x | x |
W | x | x | x | W
| x | x | x | x |
- | x | x | x | -
| - | x | x | - |
- | - | B | - | -
map

parser = Engine::Parser.new

plots_attributes = parser.from_matrix(plots_map, "x").map      {|cell| plots[cell[:sign]].merge x: cell[:x], y: cell[:y] }
units_attributes = parser.from_matrix(units_map, "W", "B").map {|cell| units[cell[:sign]].merge x: cell[:x], y: cell[:y] }

cancer = Planet.create! name: "Cancer", description: "...", w: 9, h: 9, plots: plots_attributes, units: units_attributes

parser.print parser.to_matrix(w: cancer.actual_w, h: cancer.actual_h, cells: cancer.plots),
             parser.to_matrix(w: cancer.actual_w, h: cancer.actual_h, cells: cancer.units)