extends Node3D

@export var short_grass_scene: PackedScene

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var shortGrass = short_grass_scene.instantiate()
		add_sibling(shortGrass)
		shortGrass.global_transform.origin = global_transform.origin
		shortGrass.scale = Vector3(0.1,0.1,0.1)
		shortGrass.rotation_degrees = rotation_degrees
		queue_free()
