extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		var current_scene = get_tree().current_scene
		get_tree().reload_current_scene()
		Engine.time_scale = 1.0
