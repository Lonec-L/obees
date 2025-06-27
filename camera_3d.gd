extends Camera3D


var offset_strength = 0.1
@export var max_side_offset := 3      # How far camera shifts during drift
@export var follow_speed := 5.0         # How smoothly camera moves
@onready var player = get_parent()

var target_local_offset := Vector3.ZERO
var current_local_offset := Vector3.ZERO

var original_position := Vector3.ZERO

func _ready():
	original_position = transform.origin

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var drift_input = Input.get_action_strength("drift")
	var side_direction = -(Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right"))
	
	if drift_input == 0:
		offset_strength = 0.2
	elif offset_strength < 1:
		offset_strength = min((offset_strength * (1 + 2 * delta)), 2)

	var target_position = transform.origin
	
	if drift_input == 0 || side_direction == 0:
		target_position = original_position
	else:
		target_position += side_direction * transform.basis.x.normalized() * offset_strength
		if (transform.origin - original_position).length() > max_side_offset:
			return
	transform.origin = transform.origin.lerp(target_position, follow_speed * delta)

	look_at(player.transform.origin, Vector3.UP)
