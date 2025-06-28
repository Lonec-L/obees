extends Node3D

@export var tree1: PackedScene
@export var tree2: PackedScene
@export var tree3: PackedScene

@export var bush1: PackedScene
@export var bush2: PackedScene
@export var bush3: PackedScene

@export var grass: PackedScene

@export var tree_scale: float = 0.3

@export var area_size: float = 100
@export var spacing: float = 1.5
@export var noise_threshold: float = 0.6

@export var starting_area: int = 20

var noise := FastNoiseLite.new()

func spawn_tree_at(pos: Vector3) -> void:
	var tree_options = [tree1, tree2, tree3, bush1, bush2, bush3]
	var chosen_tree_scene = tree_options[randi() % tree_options.size()]
	
	var tree_instance = chosen_tree_scene.instantiate()
	tree_instance.position = pos
	tree_instance.rotation_degrees.y = randf() * 360
	tree_instance.scale *= Vector3(tree_scale,tree_scale,tree_scale) * (0.8 + 0.4*randf())
	add_child(tree_instance)
	
func spawn_grass_at(pos: Vector3) -> void:
	var grass_instance = grass.instantiate()
	grass_instance.position = pos
	grass_instance.scale = Vector3(0.1,0.1,0.1)
	grass_instance.rotation_degrees.y = randf() * 360
	add_child(grass_instance)

func _ready():
	var y = 0
	noise.seed = randi()
	noise.frequency = 0.5
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	  # Only spawn trees where noise is above this
	var x = -area_size
	while x < area_size:
		var z = -area_size
		while z < area_size:
			if x*x + z*z > area_size*area_size:
				z += spacing
				continue
			var diff = abs(x*x + z*z - area_size*area_size)
			var world_x = float(x)
			var world_z = float(z)

			var value = noise.get_noise_2d(world_x, world_z)  # Range: [-1, 1]

			if value > noise_threshold && (abs(world_x) > starting_area ||  abs(world_z) > starting_area):
				  # Replace with terrain height if needed
				spawn_tree_at(Vector3(world_x, y, world_z))
			elif diff > 6000:
				spawn_grass_at(Vector3(world_x, y, world_z))
			elif value > noise_threshold/2:
				spawn_grass_at(Vector3(world_x, y, world_z))
			
			z += spacing
		x += spacing



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
