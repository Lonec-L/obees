extends Node3D

@export var bee_scene: PackedScene
@export var spawn_radius = 30.0
@export var spawn_interval = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_timer_timeout() -> void:
	var bee = bee_scene.instantiate()
	bee.speed = 12
	get_tree().current_scene.add_child(bee)
	bee.global_transform.origin = Vector3(
		randf_range(-spawn_radius, spawn_radius),
		3,
		randf_range(-spawn_radius, spawn_radius)
	)
	

	 
