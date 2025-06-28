extends CharacterBody3D

const SPEED = 10.0              # Constant forward speed
const TURN_SPEED = 1.0         # How fast the player rotates (adjust as needed)
var drift_strength = 0
var movement_enabled: bool = true
var _last_drift_dir = 0

@export var mg_scene: PackedScene

func _physics_process(delta):
	
	if !movement_enabled:
		return
	# Rotate left/right using input
	var turn_input = Input.get_action_strength("ui_left") - Input.get_action_strength("ui_right")
	if _last_drift_dir != turn_input:
		drift_strength = 0
	_last_drift_dir = turn_input
	var drift_input = Input.get_action_strength( "drift")
	rotation.y += turn_input * (TURN_SPEED + 0.4*drift_input) * delta
	
	if drift_input == 0:
		drift_strength = 0
	elif drift_strength < 1:
		drift_strength = min(drift_strength + 0.5 * delta, 1)
	# Constant forward movement in local z-axis
	var forward_direction = -transform.basis.z.normalized()
	
	var drift_direction = drift_input * turn_input * transform.basis.x.normalized()
	velocity = (4*drift_direction*drift_strength + forward_direction).normalized() * SPEED
	
	velocity -= transform.basis.y.normalized()*3
		
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("gTrees") && movement_enabled:
			var ui = mg_scene.instantiate()
			add_child(ui)
			ui.start_stun_minigame()
			movement_enabled = false
