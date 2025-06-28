extends Node3D

@export var bob_speed: float = 1.0         # Speed of bobbing (cycles per second)
@export var bob_amplitude: float = 0.25    # How high to bob
@export var rotate_speed: float = 0.5      # Radians per second

var base_y: float = 0.0                    # Original Y position
var time_passed: float = 0.0               # Tracks time

func _ready():
	base_y = global_transform.origin.y
	scale = Vector3(0.2,0.2,0.2)

func _process(delta: float) -> void:
	time_passed += delta

	# Bobbing up and down
	var new_y = base_y + sin(time_passed * TAU * bob_speed) * bob_amplitude
	var pos = global_transform.origin
	pos.y = new_y
	global_transform.origin = pos

	# Rotate around Y axis
	rotate_y(rotate_speed * delta)


func _on_area_3d_body_entered(player):
	if player.is_in_group("player"):
		player.get_epipen()
		queue_free()
