extends Node3D

@export var short_grass_scene: PackedScene

func _on_area_3d_area_entered(area: Area3D) -> void:
	print("entered area")



func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		var shortGrass = short_grass_scene.instantiate()
		shortGrass.global_transform.origin = global_transform.origin
		shortGrass.scale = Vector3(0.1,0.1,0.1)
		add_sibling(shortGrass)
		queue_free()
