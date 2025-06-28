extends Node3D

@export var short_grass: PackedScene

var t = 0
var spawned := false


# Called when the node enters the scene tree for the first time.
func _process(delta: float) -> void:
	if not spawned:
		t += delta
		if t >= 0.2:
			spawn_grass()
			spawned = true

func spawn_grass() -> void:
	if short_grass:
		var grass_instance = short_grass.instantiate()
		grass_instance.global_transform = self.global_transform
		get_parent().add_child(grass_instance)
		queue_free()  # Optional: remove this node after spawning
