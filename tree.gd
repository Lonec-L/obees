extends StaticBody3D

func fall():
	collision_layer = 0
	collision_mask = 0

	# Fall around the local right axis
	var axis = global_transform.basis.x.normalized()
	var rotation_quat = Quaternion(axis, deg_to_rad(90))
	
	var new_basis = global_transform.basis.rotated(axis, deg_to_rad(90))
	var new_transform = global_transform
	new_transform.basis = new_basis

	# Tween the full transform (or just the basis if you prefer)
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_transform", new_transform, 1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.connect("finished", Callable(self, "_on_fall_finished"))

func _on_fall_finished():
	queue_free()
