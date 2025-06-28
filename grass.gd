extends Node3D

@export var short_grass_scene: PackedScene

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("player"):
		var shortGrass = short_grass_scene.instantiate()
		shortGrass.global_transform.origin = global_transform.origin
		queue_free()
