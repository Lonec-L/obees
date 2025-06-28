extends Node3D

@export var tree1: PackedScene
@export var tree2: PackedScene
@export var tree3: PackedScene

@export var tree_scale: float = 0.3

@export var area_size: int = 100
@export var spacing: int = 5
@export var noise_threshold: float = 0.5

var noise := FastNoiseLite.new()

func spawn_tree_at(pos: Vector3) -> void:
	var tree_options = [tree1, tree2, tree3]
	var chosen_tree_scene = tree_options[randi() % tree_options.size()]
	
	var tree_instance = chosen_tree_scene.instantiate()
	tree_instance.position = pos
	tree_instance.rotation_degrees.y = randf() * 360
	tree_instance.scale = Vector3(tree_scale,tree_scale,tree_scale)
	add_child(tree_instance)

func _ready():
	noise.seed = randi()
	noise.frequency = 0.05
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	var area_size = 100  # Size of the map
	  # Only spawn trees where noise is above this
	for x in range(-area_size/2, area_size/2, spacing):
		for z in range(-area_size/2, area_size/2, spacing):
			var world_x = float(x)
			var world_z = float(z)

			var value = noise.get_noise_2d(world_x, world_z)  # Range: [-1, 1]

			if value > noise_threshold:
				var y = 0  # Replace with terrain height if needed
				spawn_tree_at(Vector3(world_x, y, world_z))



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
