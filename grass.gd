extends Node3D

@export var mid_grass_scene: PackedScene

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var midGrass = mid_grass_scene.instantiate()
		add_sibling(midGrass)
		midGrass.global_transform.origin = global_transform.origin
		midGrass.scale = Vector3(0.1,0.1,0.1)
		midGrass.rotation_degrees = rotation_degrees
		queue_free()
