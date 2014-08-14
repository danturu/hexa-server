puts "Creating universe from nothing..."

if Rails.env.development?
  Doorkeeper::Application.create! name: "hexa-webapp",  uid: ENV["DEV_GAME_PUBLIC_KEY"], secret: ENV["DEV_GAME_SECRET_KEY"], redirect_uri: ENV["DEV_GAME_REDIRECT_URI"]
end

def image_path(path)
  File.open(File.join(__dir__, "assets/images/#{path}"))
end

def plot_sprite(tag, image)
  { tag: tag, sprite_w: 210, sprite_h: 182, file: image_path("plots/#{image}.png") }
end

def unit_sprite(tag, image)
  { tag: tag, sprite_w: 220, sprite_h: 220, file: image_path("units/#{image}.png") }
end

puts "Creating plots..."

stone = Plot.create tag: "stone", char: "x"
stone.images.create plot_sprite "",       "stone"
stone.images.create plot_sprite "active", "stone-active"
stone.images.create plot_sprite "clone",  "stone-clone"
stone.images.create plot_sprite "move",   "stone-move"

# exporting plots for map parser

plots = Hash.new
plots["x"] = { object: stone }

puts "Creating units..."

blue_unit = Unit.create tag: "blue", char: "B"
blue_unit.images.create unit_sprite "",      "blue"
blue_unit.images.create unit_sprite "clown", "blue-clown"
blue_unit.images.create unit_sprite "die",   "blue-die"
blue_unit.images.create unit_sprite "live",  "blue-live"
blue_unit.images.create unit_sprite "move",  "blue-move"

green_unit = Unit.create tag: "green", char: "G"
green_unit.images.create unit_sprite "",      "green"
green_unit.images.create unit_sprite "clown", "green-clown"
green_unit.images.create unit_sprite "die",   "green-die"
green_unit.images.create unit_sprite "live",  "green-live"
green_unit.images.create unit_sprite "move",  "green-move"

# exporting units for map parser

units = Hash.new
units["B"] = { object: blue_unit,  metadata: { owner: "white" } }
units["G"] = { object: green_unit, metadata: { owner: "black" } }

puts "Creating Cancer planet..."

plots_map = <<-map
- | - | x | - | -
| - | x | x | - |
- | x | x | x | -
| x | x | x | x |
x | x | x | x | x
| x | x | x | x |
x | x | - | x | x
| x | x | x | x |
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
- | - | B | - | -
| - | x | x | - |
- | x | x | x | -
| x | x | x | x |
G | x | x | x | G
| x | x | x | x |
x | x | - | x | x
| x | x | x | x |
x | x | x | x | x
| x | - | - | x |
x | x | x | x | x
| x | x | x | x |
B | x | x | x | B
| x | x | x | x |
- | x | x | x | -
| - | x | x | - |
- | - | G | - | -
map

parser = Engine::Parser.new

plots_attributes = parser.from_matrix(plots_map, "x").map      {|cell| plots[cell[:char]].merge x: cell[:x], y: cell[:y] }
units_attributes = parser.from_matrix(units_map, "B", "G").map {|cell| units[cell[:char]].merge x: cell[:x], y: cell[:y] }

cancer = Planet.create! name: "Cancer", description: "...", w: 9, h: 9, plots: plots_attributes, units: units_attributes, image: image_path("planets/cancer.png")

parser.print parser.to_matrix(w: cancer.actual_w, h: cancer.actual_h, cells: cancer.plots),
             parser.to_matrix(w: cancer.actual_w, h: cancer.actual_h, cells: cancer.units)
