extends Node3D

@export var bee_scene: PackedScene
@export var spawn_radius = 10.0
@export var spawn_interval = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Timer.wait_time = spawn_interval
	$Timer.start()

func _on_timer_timeout() -> void:
	var bee = bee_scene.instantiate()

	bee.global_transform.origin = global_transform.origin + Vector3(
		randf_range(-spawn_radius, spawn_radius),
		randf_range(1, 2),
		randf_range(-spawn_radius, spawn_radius)
	)
	var scale = randf_range(0.1, 0.3)
	bee.scale = Vector3(scale, scale, scale)
	get_tree().current_scene.add_child(bee) 
